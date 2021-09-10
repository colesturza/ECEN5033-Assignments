import requests
import time


def main():
    for _ in range(10):
        response = requests.get('http://127.0.0.1:5000/')
        print(response.text)

        time.sleep(2)


if __name__ == '__main__':
    main()
