defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  alias Rocketpay.User
  alias Rocketpay.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "mateus",
        password: "123456",
        nickname: "mat",
        email: "mateus@email.com",
        age: 18
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "mateus", age: 18, id: ^user_id} = user
    end

    test "when all params are invalid, returns an error" do
      params = %{
        name: "mateus",
        password: "123456",
        nickname: "mat",
        age: 11
      }

      {:error, changeset} = Create.call(params)

      _expected_response = %{
        age: ["must be greater than or equal to 18"],
        email: ["can't be blank"]
      }

      assert _expected_response = errors_on(changeset)
    end
  end
end
