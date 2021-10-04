import requests
import json
import argparse
import re
import sys
import subprocess
import time

URL_ETCD = "http://192.168.33.10:2379"


def main(version, init=False, verbose=False):

    # initialize etcd, registrator, and blue/green keys
    if init:
        if verbose:
            print("Initializing environment.")
        subprocess.Popen(["bash", "run_etcd.sh", "1", "1"]).wait()
        subprocess.Popen(["bash", "run_registrator.sh"]).wait()
        subprocess.Popen(["bash", "init.sh"]).wait()

    # get the current color from etcd
    url = URL_ETCD + "/v2/keys/color/current_color"
    response = requests.request("GET", url)
    r = json.loads(response.text)
    current_color = r["node"]["value"]

    # set the new color
    new_color = None
    if current_color == "blue":
        new_color = "green"
    if current_color == "green":
        new_color = "blue"

    if verbose:
        print(f"Set new color to {new_color}.")

    # get ip and port for new version
    url = URL_ETCD + f"/v2/keys/color/{new_color}_port"
    response = requests.request("GET", url)
    r = json.loads(response.text)
    port = r["node"]["value"]

    service_dir = "server_" + version
    service_instance_name = "server_" + new_color

    # start the new version's container
    if verbose:
        print(f"Starting new container for {service_dir} as {service_instance_name}.")
    subprocess.Popen(["docker", "build", "-t", "server", f"./{service_dir}"]).wait()
    subprocess.Popen(
        [
            "docker",
            "run",
            "-d",
            "--rm",
            "-p",
            f"{port}:80",
            "--name",
            service_instance_name,
            "server",
        ]
    ).wait()

    time.sleep(2)  # health check occurs to earlier, need to wait 2 seconds before sending.

    if verbose:
        print("Performing health check.")

    # get ip and port for new version
    url = f"http://192.168.33.10:{port}"
    response = requests.request("GET", url)
    if response.status_code != 200:
        if verbose:
            print("Health check failed. Stopping container.")
            subprocess.Popen(["docker", "stop", service_instance_name]).wait()
            subprocess.Popen(["bash", "remove_exited_containers.sh"]).wait()
            sys.exit(0)

    if verbose:
        print(f"Recieved message: {response.text}")

    # run confd
    subprocess.Popen(["bash", "run_confd.sh"], cwd="/home/vagrant/confd").wait()

    # move the new config file to nginx directory
    subprocess.Popen(
        [
            "sudo",
            "cp",
            "/home/vagrant/confd/out/nginx.conf",
            "/home/vagrant/nginx",
        ]
    ).wait()
    subprocess.Popen(
        [
            "sudo",
            "cp",
            "/home/vagrant/confd/out/nginx.conf",
            "/home/vagrant/nginx/etc_nginx",
        ]
    ).wait()

    # either start up nginx or reload it
    if init:
        subprocess.Popen(["bash", "build_nginx.sh"], cwd="/home/vagrant/nginx").wait()
        subprocess.Popen(["bash", "run_nginx.sh"], cwd="/home/vagrant/nginx").wait()
    else:
        subprocess.Popen(["docker", "container", "exec", "nginx-container", "nginx", "-s", "reload"]).wait()
        # stop all old containers and remove them
        subprocess.Popen(["docker", "stop", "server_" + current_color]).wait()
        subprocess.Popen(["bash", "remove_exited_containers.sh"]).wait()

    # change the current color
    subprocess.Popen(["etcdctl", "set", "color/current_color", new_color]).wait()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process version.")
    parser.add_argument(
        "version",
        help="a version of server to upgrade to. Must be of the form `vX.X.X`",
    )
    parser.add_argument("-i", "--init", action="store_true", help="initialize environment")
    parser.add_argument("-v", "--verbose", action="store_true", help="increase output verbosity")
    args = parser.parse_args()
    version = args.version
    init = args.init
    verbose = args.verbose

    # check version is of correct form
    pattern = re.compile(r"v\d+(?:\.\d+)+")
    if not re.fullmatch(pattern, version):
        parser.print_help()
        sys.exit(0)

    main(version, init=init, verbose=verbose)
