FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y netcat-openbsd 

COPY requirements.txt /app

RUN apt-get update && apt-get install -y \
    pkg-config \
    libmariadb-dev-compat \
    gcc 

ENV PYTHONUNBUFFERED=1

# Then, you can install the Python dependencies
RUN pip install --upgrade pip &&\
    pip install -r requirements.txt

COPY . /app

CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]

# RUN chmod +x /app/entrypoint.sh

# ENTRYPOINT ["sh","/niab_django/entrypoint.sh"]




