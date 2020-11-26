FROM arm64v8/python:3.10.0a2-buster
COPY ./src /app
WORKDIR /app
ENTRYPOINT [ "python", "app.py" ]
