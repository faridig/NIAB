FROM python:3.11-slim

WORKDIR /api

COPY . /api

RUN apt-get update && apt-get install -y pkg-config libmariadb-dev-compat libmariadb-dev

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

 
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]