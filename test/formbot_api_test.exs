defmodule FormbotApiTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  @opts FormbotApi.Router.init([])

  describe "/auth" do
    test "return Unauthorized when basic auth failed" do
      conn =
        :get
        |> conn("/auth", "")
        |> FormbotApi.Router.call(@opts)

      assert conn.status == 401
    end

    test "return token when basic auth pass" do
      # Test basic auth: test:test
      mock_token = "token"

      with_mock FormbotApi.AuthTokenRepository, find_or_create_token: fn -> {:ok, mock_token} end do
        conn =
          :get
          |> conn("/auth", "")
          |> put_req_header("authorization", "Basic dGVzdDp0ZXN0")
          |> FormbotApi.Router.call(@opts)

        assert conn.status == 200
        assert conn.resp_body == mock_token
      end
    end
  end
end
