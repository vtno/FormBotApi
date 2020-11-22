defmodule FormbotApi.AuthTokenRepository do
  @db_path Application.get_env(:formbot_api, :db_path, "sqlite/dev.db")

  def find_token do
    Sqlitex.with_db(@db_path, fn db ->
      Sqlitex.query(
        db,
        "SELECT token FROM auth_tokens WHERE expired_at > datetime() ORDER BY expired_at LIMIT 1"
      )
    end)
  end

  def create_token do
    token = SecureRandom.hex()

    Sqlitex.with_db(@db_path, fn db ->
      Sqlitex.query(
        db,
        "INSERT INTO auth_tokens (token, expired_at, created_at) VALUES ('#{token}', datetime(datetime(), \"+1 hour\"), datetime())"
      )
    end)

    {:ok, token}
  end

  defp create_or_return(token) do
    case length(token) do
      0 -> create_token()
      _ -> token |> List.first() |> Keyword.fetch(:token)
    end
  end

  def find_or_create_token do
    case find_token() do
      {:ok, token} -> create_or_return(token)
      {:error, err} -> {:error, err}
    end
  end
end
