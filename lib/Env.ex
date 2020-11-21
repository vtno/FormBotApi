defmodule Env do
  @env Application.compile_env(:formbot_api, :env)

  defp current(), do: @env
  def is_prod(), do: current() == "prod"
  def is_dev(), do: current() == "dev"
  def is_test(), do: current() == "test"
end
