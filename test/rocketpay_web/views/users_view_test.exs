defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Phoenix.View

  alias RocketpayWeb.UsersView

  alias Rocketpay.{Account, User}

  test "renders create.json" do
    params = %{
      name: "mateus",
      password: "123456",
      nickname: "mat",
      email: "mateus@email.com",
      age: 18
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{balance: Decimal.new("0.00"), id: account_id},
        id: user_id,
        name: "mateus",
        nickname: "mat"
      }
    }

    assert expected_response == response
  end
end
