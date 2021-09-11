FROM python:3
ENV PYTHONUNBUFFERED 1
ADD . /client_app
WORKDIR /client_app
COPY requirements.txt /client_app/
RUN pip install -r requirements.txt
COPY . /client_app/
CMD ["python", "main.py"]
