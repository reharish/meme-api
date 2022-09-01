FROM python:3-onbuild
COPY . /usr/src/app
CMD ["gunicorn", "app:app", "-c", "gunicorn.wsgi.py"]