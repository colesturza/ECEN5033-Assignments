FROM python:3
ENV PYTHONUNBUFFERED=1
ADD . /server_app
WORKDIR /server_app
COPY requirements.txt /server_app/
RUN pip install -r requirements.txt
COPY . /server_app/
CMD ["flask", "run"]
