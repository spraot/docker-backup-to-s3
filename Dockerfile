FROM python:3.11-slim-bullseye

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get update \
    && apt-get -y upgrade

RUN apt-get -y install \
    cron \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY put.sh start.sh ./
RUN chmod +x *.sh

ENTRYPOINT ["./start.sh"]
CMD [""]
