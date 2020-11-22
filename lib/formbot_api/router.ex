import Plug.BasicAuth

defmodule FormbotApi.Router do
  use Plug.Router
  use FormbotApi

  unless Env.is_test(), do: plug(Plug.SSL)
  unless Env.is_test(), do: plug(Plug.Logger)
  plug(:basic_auth, Application.compile_env(:formbot_api, :basic_auth))
  plug(:match)
  plug(:dispatch)

  get "/auth" do
    case AuthTokenRepository.find_or_create_token() do
      {:error, _} -> send_resp(conn, 400, "")
      {:ok, token} -> send_resp(conn, 200, token)
    end
  end

  get "/run-bot" do
    try do
      IO.puts("Running command: `docker run formbot`")
      System.cmd("docker", ["run", "formbot"], into: IO.stream(:stdio, :line))
      send_resp(conn, 200, "Done")
    rescue
      e in ErlangError ->
        IO.puts("Error occured: ")
        IO.inspect(e)
        send_resp(conn, 500, "Failed")
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
