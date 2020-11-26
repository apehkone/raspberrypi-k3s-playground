FROM balenalib/raspberry-pi-debian:latest

RUN apt-get -qqy update && apt-get install -qqy \
  sense-hat

COPY ./src /app
WORKDIR /app
ENTRYPOINT [ "python", "app.py" ]
