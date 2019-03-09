defmodule Companies.Schema.UserTest do
  @moduledoc """
  This module contains unit tests for the User changeset.
  """
  use Companies.DataCase

  alias Companies.Schema.User

  @valid_user %{
    email: "test@example.com",
    nickname: "doomspork",
    token: "qwerty123"
  }

  describe "user changesets" do
    test "validates correct parameters" do
      changeset = User.changeset(%User{}, @valid_user)
      assert changeset.valid?
    end

    test "invalid with empty parameters" do
      changeset = User.changeset(%User{}, %{})
      refute changeset.valid?
    end
  end
end
