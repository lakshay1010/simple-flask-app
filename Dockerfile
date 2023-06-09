# https://pythonspeed.com/articles/base-image-python-docker-images/
FROM python:3.11-slim-bullseye

# This prevents Python from writing out pyc files (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1
# This keeps Python from buffering stdin/stdout (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1

# run as a non-root user
# https://pythonspeed.com/articles/root-capabilities-docker-security/
# https://pythonspeed.com/articles/security-updates-in-docker/
RUN useradd --create-home appuser
USER appuser

# set workdir
WORKDIR /app

# copy requirements.txt to workdir and install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt
COPY . .

RUN pip install gunicorn

EXPOSE 5000

# gunicorn app:app --access-logfile gunicorn.log
# CMD [ "gunicorn", "app:app"]
# CMD [ "gunicorn", "--bind=0.0.0.0:5000", "app:app"]
# CMD [ "gunicorn", "app:app", "--access-logfile gunicorn.log"]
# CMD [ "gunicorn", "app:app", "--access-logfile -"]
# CMD ["python", "-m", "gunicorn", "--bind=0.0.0.0:5000", "app:app"]
# CMD ["python", "-m", "gunicorn", "--bind=0.0.0.0:5000", "app:app", "--access-logfile=-"]
CMD ["python", "-m", "gunicorn", "--bind=0.0.0.0:5000", "app:app", "--access-logfile=-", "--reload"]
# CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]

