FROM python:slim-bullseye

COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]