defmodule Companies.AccountsTest do
  use Companies.DataCase

  alias Companies.Accounts

  describe "create/1" do
    test "creates a new account" do
      assert {:ok, %{id: _id}} = Accounts.create(%{email: "test@example.com", nickname: "doomspork", token: "abc123"})
    end
  end

  describe "get!/1" do
    test "gets a user" do
      %{id: admin_id} = insert(:user, nickname: "doomspork", admin: true)
      assert %{admin: true} = Accounts.get!(admin_id)
    end
  end

  describe "get_user_by_email/1" do
    test "gets a user by email" do
      %{email: email, id: id} = insert(:user)
      assert %{email: ^email, admin: false, id: ^id} = Accounts.get_by_email(email)
    end
  end

  describe "for_hire/1" do
    test "returns an empty list if no developers are for hire" do
      insert(:user)

      assert %{entries: []} = Accounts.for_hire(%{})
    end

    test "returns a list of users for hire" do
      insert(:user)
      %{email: email, id: id} = insert(:user, looking_for_job: true)
      %{entries: [%{email: ^email, id: ^id, looking_for_job: true}]} = Accounts.for_hire(%{})
    end
  end

  describe "change/1" do
    test "creates a changeset for user details" do
      user = insert(:user)
      assert %Ecto.Changeset{data: ^user} = Accounts.change(user)
    end
  end

  describe "update/2" do
    test "updates a user given some changes" do
      user = insert(:user)
      assert {:ok, %Companies.Schema.User{looking_for_job: true}} = Accounts.update(user, %{looking_for_job: true})
    end
  end

  describe "list_users/0" do
    test "returns an empty list if no user exists" do
      assert [] == Accounts.list_users()
    end

    test "returns a list of users" do
      %{id: id} = insert(:user)
      assert [%Companies.Schema.User{id: ^id}] = Accounts.list_users()
    end
  end

  describe "toggle_admin/1" do
    test "given a simple user, gets converted to an admin" do
      user = insert(:user)
      assert user.admin == false
      assert {:ok, %Companies.Schema.User{admin: true}} = Accounts.toggle_admin(user)
    end

    test "given an admin, gets converted to a simple user" do
      user = insert(:user, admin: true)
      assert {:ok, %Companies.Schema.User{admin: false}} = Accounts.toggle_admin(user)
    end
  end
end
