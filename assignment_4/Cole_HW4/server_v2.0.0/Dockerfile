# syntax=docker/dockerfile:1

FROM python:3

ENV PYTHONUNBUFFERED=1

ADD . /server_v2
WORKDIR /server_v2

COPY requirements.txt /server_v2/
RUN pip install -r requirements.txt

COPY . /server_v2/

EXPOSE 8080

CMD ["flask", "run", "-h", "0.0.0.0", "-p", "8080"]
