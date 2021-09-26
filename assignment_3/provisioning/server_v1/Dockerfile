# syntax=docker/dockerfile:1

FROM python:3

ENV PYTHONUNBUFFERED=1

ADD . /server_v1
WORKDIR /server_v1

COPY requirements.txt /server_v1/
RUN pip install -r requirements.txt

COPY . /server_v1/

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "80"]
