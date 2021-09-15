import requests
import time


def main():
    host = "172.18.0.2"
    port = "80"

    for _ in range(10):
        response = requests.get(f'http://{host}:{port}/')
        print(response.text)

        time.sleep(2)


if __name__ == '__main__':
    main()
