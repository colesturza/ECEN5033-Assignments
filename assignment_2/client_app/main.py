import requests
import time


def main():
    host = "localhost"
    port = "6666"

    for _ in range(10):
        response = requests.get(f'http://{host}:{port}/')
        print(response.text)

        time.sleep(2)


if __name__ == '__main__':
    main()
