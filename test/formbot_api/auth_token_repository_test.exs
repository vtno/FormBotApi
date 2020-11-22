defmodule FormbotApi.AuthTokenRepositoryTest do
  use ExUnit.Case, async: false
  use FormbotApi

  @db_path Application.get_env(:formbot_api, :db_path, "sqlite/dev.db")
  @time_format "{YYYY}-{0M}-{D} {h24}:{m}:{s}"

  defp create_token(token, datetime) do
    Sqlitex.with_db(@db_path, fn db ->
      Sqlitex.query(
        db,
        "INSERT INTO auth_tokens (token, expired_at, created_at) VALUES ('#{token}', '#{datetime}', datetime())"
      )
    end)
  end

  defp clear_token() do
    Sqlitex.with_db(@db_path, fn db ->
      Sqlitex.query(
        db,
        "DELETE FROM auth_tokens"
      )
    end)
  end

  setup do
    clear_token()
    on_exit(fn -> clear_token() end)
  end

  test "find_or_create should create token if no unexpired token" do
    yesterday = Timex.format!(Timex.shift(Timex.now(), days: -1), @time_format)
    expired_token = SecureRandom.hex()
    create_token(expired_token, yesterday)

    {:ok, token} = AuthTokenRepository.find_or_create_token()

    assert token != nil
    assert token != expired_token
  end

  test "find_or_create should NOT create token if there is unexpired token" do
    tomorrow = Timex.format!(Timex.shift(Timex.now(), days: 1), @time_format)
    unexpired_token = SecureRandom.hex()
    create_token(unexpired_token, tomorrow)

    {:ok, token} = AuthTokenRepository.find_or_create_token()

    assert token != nil
    assert token == unexpired_token
  end

  test "find_token should return token if exist an NOT expired" do
    now = Timex.now()
    yesterday = Timex.format!(Timex.shift(now, days: -1), @time_format)
    tomorrow = Timex.format!(Timex.shift(now, days: 1), @time_format)
    day_after_tomorrow = Timex.format!(Timex.shift(now, days: 2), @time_format)

    token = SecureRandom.hex()
    create_token(SecureRandom.hex(), day_after_tomorrow)
    create_token(token, tomorrow)
    create_token(SecureRandom.hex(), yesterday)

    {:ok, [[token: result]]} = AuthTokenRepository.find_token()

    assert result == token
  end

  test "find_token should NOT return token if token NOT exist" do
    assert {:ok, []} = AuthTokenRepository.find_token()
  end
end
