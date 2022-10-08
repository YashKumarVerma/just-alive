FROM ubuntu:22.10

RUN apt-get update  -y
RUN apt-get upgrade -y

COPY ./dist/app ./app

# CMD ["sh", "-c", "./app"]

ENTRYPOINT [ "./app" ]
