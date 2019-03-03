defmodule Companies.AccountsTest do
  use Companies.DataCase

  alias Companies.Accounts

  describe "create/1" do
    test "creates a new account and assigns maintainer status" do
      assert {:ok, %{id: _id, maintainer: true}} =
               Accounts.create(%{email: "test@example.com", nickname: "doomspork", token: "abc123"})
    end
  end

  describe "get!/1" do
    test "gets a user and assigns maintainer status" do
      %{id: maintainer_id} = insert(:user, nickname: "doomspork")
      assert %{maintainer: true} = Accounts.get!(maintainer_id)

      %{id: nonmaintainer_id} = insert(:user)
      assert %{maintainer: false} = Accounts.get!(nonmaintainer_id)
    end
  end

  describe "get_user_by_email/1" do
    test "gets a user by email" do
      %{email: email, id: id} = insert(:user)
      assert %{email: ^email, maintainer: false, id: ^id} = Accounts.get_user_by_email(email)
    end
  end
end
