FROM frolvlad/alpine-glibc
RUN apk --no-cache add ca-certificates
COPY app-linux /app
ENTRYPOINT /app