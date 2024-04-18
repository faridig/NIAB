FROM python:3.11-slim

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y pkg-config libmariadb-dev-compat libmariadb-dev

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8000

 
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]