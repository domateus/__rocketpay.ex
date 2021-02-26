defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "mateus",
        password: "123456",
        nickname: "mat",
        email: "mateus@email.com",
        age: 18
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic bWF0ZXVzOjEyMzQ1Ng==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "100.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "100.00", "id" => _id},
               "message" => "Balance updated"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "invalid_param"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      _expected_response = %{"message" => "Invalid deposit value"}

      assert _expected_response = response
    end
  end
end
