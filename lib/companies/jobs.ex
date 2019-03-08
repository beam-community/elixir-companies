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
  def all(params \\ %{}) do
    page = Map.get(params, "page", "1")

    (j in Job)
    |> from()
    |> where([j], is_nil(j.removed_pending_change_id))
    |> predicates(params)
    |> order_by(desc: :updated_at)
    |> preload(:company)
    |> Repo.paginate(page: page)
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
  def get!(id) do
    (j in Job)
    |> from()
    |> where([j], is_nil(j.removed_pending_change_id))
    |> Repo.get!(id)
  end

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

  def predicates(query, %{"search" => search_params}) do
    Enum.reduce(search_params, query, &query_predicates/2)
  end

  def predicates(query, _), do: query

  defp query_predicates({"remote_only", "on"}, query) do
    from c in query, where: c.remote == true
  end

  defp query_predicates({"text", text}, query) do
    text = String.trim(text)

    from c in query, where: ilike(c.title, ^"%#{text}%")
  end

  defp query_predicates(nil, query), do: query
end
