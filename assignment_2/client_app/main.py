import requests
import time
import os


def main():

    port = os.environ["PORT"]
    host = os.environ["HOST"]
    period = int(os.environ["PERIOD"])
    repititions = int(os.environ["REPITITIONS"])

    for _ in range(repititions):
        response = requests.get(f"http://{host}:{port}/")
        print(response.text)

        time.sleep(period)


if __name__ == "__main__":
    main()
