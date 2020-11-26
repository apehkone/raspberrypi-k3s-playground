FROM balenalib/raspberrypi4-64-debian-python:3.7.3-stretch-build as builder
# Always set a working directory
WORKDIR /app
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Make sure we use the virtualenv:
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# Use `install_packages` if you need to install dependencies
RUN pip install -U pip && \
    pip install -U wheel && \
    pip install -U numpy && \
    pip install -U pillow
# RTIMU library fix
RUN git clone https://github.com/RPi-Distro/RTIMULib/ RTIMU
WORKDIR /app/RTIMU/Linux/python
RUN python setup.py build && \
    python setup.py install
# reset working directory
WORKDIR /app
# This will copy all files in our root to the working  directory in the container
COPY ./src/requirements.txt ./
RUN pip install -U --no-cache-dir -r requirements.txt

####################################################################################################
# Robert test
RUN  apt-get update && \
 apt-get install -y curl gnupg2

RUN gpg --keyserver keys.gnupg.net --recv-key 82B129927FA3303E && \
 gpg -a --export 82B129927FA3303E | apt-key add -

RUN echo 'deb http://archive.raspberrypi.org/debian stretch main' >> /etc/apt/sources.list && \
 apt-get update && \
 apt-get install -y sense-hat

####################################################################################################

# Trimmed down app container
FROM balenalib/raspberrypi4-64-debian-python:3.7.3-stretch-build as app
# Extra python env
ENV LANG=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Use `install_packages` if you need to install dependencies
RUN install_packages libjpeg62-turbo-dev
# Make sure we use the virtualenv:
COPY --from=0 /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# Always set a working directory
WORKDIR /app

COPY ./src /app
# Enable udevd so that plugged dynamic hardware devices show up in our container.
ENV UDEV=1
# main.py will run when container starts up on the device
CMD ["python", "-u", "app.py"]
