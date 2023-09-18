# -------------------------------------------------------------------------------
FROM python:3.8.11-alpine3.14 as compile-stage-1

WORKDIR /service/app
COPY requirements.txt /service/app/
RUN apk add --no-cache curl build-base npm
RUN pip install --upgrade pip && \
    pip install --prefix=/pyinstall -r requirements.txt

# -------------------------------------------------------------------------------
FROM python:3.8.11-alpine3.14 as compile-stage-2

WORKDIR /service/stress
RUN apk add --no-cache git go
RUN git clone https://github.com/jaeg/NodeWrecker.git && \
    cd NodeWrecker && \
    go build -o nodeStress main.go && \
    mv ./nodeStress /service/stress/nodeStress

# -------------------------------------------------------------------------------
FROM python:3.8.11-alpine3.14 as build-stage

LABEL description="Imagen docker de Servidor con FastAPI" \
      mantainer="Zasema <zasema.devops@gmail.com>"

COPY --from=compile-stage-1 /pyinstall /usr/local

WORKDIR /service/stress
COPY --from=compile-stage-2 /service/stress/nodeStress /service/stress/nodeStress

WORKDIR /service/app
ADD ./src/ /service/app/
RUN addgroup -S zasema && \
    adduser -S zasema -G zasema && \
    chown -R zasema:zasema /service/app /service/stress

USER zasema

EXPOSE 8081

ENV PYTHONUNBUFFERED 1

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=5 \
    CMD curl -s --fail http://localhost:8081/health || exit 1

CMD ["python3", "-u", "app.py"]
