FROM python:3.8

WORKDIR /app

COPY requirements.txt .
COPY rotate_keys.py .

RUN pip3 install -r requirements.txt

CMD [ "python", "/app/rotate_keys.py" ]
