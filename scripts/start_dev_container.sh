#! /bin/sh
docker run -it --rm -v $(pwd):/workspace -u $(id -u) --name formbot-api-devbox formbot-api
