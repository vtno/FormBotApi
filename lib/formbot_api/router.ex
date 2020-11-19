defmodule FormbotApi.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

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
