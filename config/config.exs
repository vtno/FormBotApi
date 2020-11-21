import Config

env = System.get_env("MIX_ENV")

config :formbot_api, :basic_auth,
  username: System.get_env("APP_USERNAME"),
  password: System.get_env("APP_PASSWORD")

config :formbot_api, :db_path, "sqlite/#{env}.db"
config :formbot_api, :env, env
