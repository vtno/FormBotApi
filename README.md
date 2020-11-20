# FormbotApi

An API to trigger FormBot

## Usage
Requires elixir 1.11.2

```
# install all dependencies
mix deps.get
# start dev server
mix run --no-halt
# run test
mix test
```

## Docker
Run `./start_dev_container.sh` to start a dev container. You can connect to it using `vscode-remote: containers` extension.

## Deployment
Copy `_build/dev/rel/prod/bin/prod` to your production machine and run `_build/dev/rel/prod/bin/prod start` to start the server.
Run `_build/dev/rel/prod/bin/prod remote` to connect to the server remotely.
Run `_build/dev/rel/prod/bin/prod stop` to stop the server gracefully.