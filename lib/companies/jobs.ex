defmodule Companies.Jobs do
  @moduledoc """
  The Jobs context.
  """

  import Ecto.Query, warn: false

  alias Companies.{Repo, PendingChanges}
  alias Companies.Schema.Job

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> all()
      [%Job{}, ...]

  """
  def all do
    Repo.all(Job)
  end

  @doc """
  Gets a single job.

  Raises `Ecto.NoResultsError` if the Job does not exist.

  ## Examples

      iex> get!(123)
      %Job{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Job, id)

  @doc """
  Submits a job listing for approval.

  ## Examples

      iex> create(%{field: value}, current_user())
      :ok

      iex> create(%{field: bad_value}, current_user())
      {:error, %Ecto.Changeset{}}

  """
  @spec create(map(), map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs, user) do
    %Job{}
    |> Job.changeset(attrs)
    |> PendingChanges.create(:create, user)
  end

  @doc """
  Updates a job.

  ## Examples

      iex> update(job, %{field: new_value})
      {:ok, %Job{}}

      iex> update(job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Job{} = job, attrs, user) do
    job
    |> Job.changeset(attrs)
    |> PendingChanges.create(:update, user)
  end

  @doc """
  Deletes a Job.

  ## Examples

      iex> delete(job)
      {:ok, %Job{}}

      iex> delete(job)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Job{} = job, user) do
    PendingChanges.create(job, :delete, user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job changes.

  ## Examples

      iex> change(job)
      %Ecto.Changeset{source: %Job{}}

  """
  def change(%Job{} = job) do
    Job.changeset(job, %{})
  end
end
