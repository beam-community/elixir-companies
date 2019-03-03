defmodule Companies.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Companies.{Repo, Schema.User}

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get!(123)
      %User{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id) do
    User
    |> Repo.get!(id)
    |> maintainer_status()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create(%{field: value})
      {:ok, %User{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert(on_conflict: {:replace, [:token]}, conflict_target: :email)
    |> maintainer_status()
  end

  @doc """
  Gets a single user, selected by email.
  """

  def get_user_by_email(email) do
    query = from(u in User, where: u.email == ^email)

    query
    |> Repo.one()
    |> maintainer_status()
  end

  defp maintainer_status({:error, reason}) do
    {:error, reason}
  end

  defp maintainer_status({:ok, user}) do
    {:ok, maintainer_status(user)}
  end

  defp maintainer_status(%{nickname: nickname} = user) do
    %{user | maintainer: nickname in maintainers()}
  end

  defp maintainers do
    :companies
    |> Application.get_env(:site_data)
    |> Map.get(:maintainers)
  end
end
