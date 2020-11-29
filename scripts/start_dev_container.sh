#! /bin/sh
docker run -it --rm -p 8080:8080 -v $(pwd):/workspace -u $(id -u) --name formbot-api-devbox formbot-api
