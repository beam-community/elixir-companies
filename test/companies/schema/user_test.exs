defmodule Companies.Schema.UserTest do
  @moduledoc """
  This module contains unit tests for the User changeset.
  """
  use Companies.DataCase

  alias Companies.Schema.User

  @valid_user_params %{
    email: "test@example.com",
    nickname: "doomspork",
    token: "qwerty123"
  }

  describe "user changesets" do
    test "returns a valid changeset with correct parameters" do
      changeset = User.changeset(%User{}, @valid_user_params)
      assert changeset.valid?
    end

    test "returns an invalid changeset for incorrect parameteres" do
      changeset = User.changeset(%User{}, %{})
      refute changeset.valid?
    end
  end
end
