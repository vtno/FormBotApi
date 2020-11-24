defmodule FormbotApi.Plug.VerifyToken do
  import Plug.Conn

  use FormbotApi

  def init(options), do: options

  def call(%Plug.Conn{request_path: path, req_headers: headers} = conn, opts) do
    if path in opts[:paths] && !verify_auth_token(headers) do
      conn
        |> send_resp(401, "Forbidden")
        |> halt()
    else
      conn
    end
  end

  defp verify_auth_token(headers) do
    headers_map = Enum.into(headers, %{})
    token = headers_map["authorization"]
    {:ok, current_token} = AuthTokenRepository.find_token()
    token == current_token
  end
end
