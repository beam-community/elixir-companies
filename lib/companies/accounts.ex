defmodule Companies.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Companies.{Repo, Schema.User}

  def for_hire(params) do
    page = Map.get(params, "page", "1")

    (u in User)
    |> from()
    |> where([u], u.looking_for_job == true)
    |> Repo.paginate(page: page)
  end

  def get_developer_profile(id) do
    Repo.get_by(User, id: id, looking_for_job: true)
  end

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
    |> Repo.insert(
      on_conflict: {:replace, [:token, :name, :nickname, :image, :description, :bio, :location]},
      conflict_target: :email
    )
    |> maintainer_status()
  end

  def change(%User{} = user) do
    User.profile_changeset(user, %{})
  end

  @doc """
  Gets a single user, selected by email.
  """
  def get_by_email(email) do
    query = from(u in User, where: u.email == ^email)

    query
    |> Repo.one()
    |> maintainer_status()
  end

  def update(%User{} = user, attrs) do
    user
    |> User.profile_changeset(attrs)
    |> Repo.update()
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
