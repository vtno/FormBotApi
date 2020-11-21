defmodule FormbotApi do
  defmacro __using__(_) do
    quote do
      alias FormbotApi.AuthTokenRepository
      alias FormbotApi.Router
    end
  end
end
