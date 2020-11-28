#! /bin/sh
set -e

export MIX_ENV=prod
export APP_USERNAME=app
export APP_PASSWORD=zumotino2020
mix deps.compile
mix release