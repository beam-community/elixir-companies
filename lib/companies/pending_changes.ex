defmodule Companies.PendingChanges do
  @moduledoc """
  The public interface to managing our pending data changes
  """

  import Ecto.Query

  alias Companies.Repo
  alias Companies.Schema.{Company, Job, Industry, PendingChange}

  @doc """
  Returns the list of paginated changes.

  ## Examples

  iex> all()
  [%PendingChange{}, ...]

  iex> all(%{"approved" => false})
  [%PendingChange{}, ...]

  iex> all(%{"approved" => true})
  [%PendingChange{}, ...]
  """
  def all(params \\ %{}) do
    page = Map.get(params, "page", "1")

    PendingChange
    |> predicates(params)
    |> preload(:reviewer)
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(page: page)
  end

  def approve(change_id, note, reviewer, false) do
    case Repo.get(PendingChange, change_id) do
      nil ->
        {:error, "change not found"}

      change ->
        update_approval(change, note, reviewer, false)
    end
  end

  def approve(change_id, note, reviewer, true) do
    with %{action: action, changes: changes, resource: resource} = change <- Repo.get(PendingChange, change_id),
         module <- resource_module(resource),
         changeset <- changeset(module, changes),
         {:ok, _changes} <- apply_changes(action, changeset, change_id) do
      update_approval(change, note, reviewer, true)
    else
      nil -> {:error, "change not found"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create(changeset, action, user)
  def create(%{valid?: false} = changes, action, _user), do: invalid_change(changes, action)
  def create(%{id: _id} = resource, action, user), do: create(%{data: resource, params: %{}}, action, user)
  def create(changes, action, user), do: insert_change(changes, action, user)

  def get(id) do
    case Repo.get(PendingChange, id) do
      nil ->
        nil

      pending_change ->
        pending_change = Repo.preload(pending_change, [:user, :reviewer])
        current = current_values(pending_change)
        %{pending_change | original: current}
    end
  end

  defp apply_changes("create", changeset, _change_id), do: Repo.insert(changeset)

  defp apply_changes("delete", record, change_id) do
    record
    |> Ecto.Changeset.cast(%{removed_pending_change_id: change_id}, [:removed_pending_change_id])
    |> Repo.update()
  end

  defp apply_changes("update", changeset, _change_id), do: Repo.update(changeset)

  defp changeset(module, changes) do
    record =
      if Map.has_key?(changes, "id") do
        id = Map.get(changes, "id")
        Repo.get(module, id)
      else
        struct(module, %{})
      end

    module.changeset(record, changes)
  end

  defp current_values(%{changes: %{"id" => id}, resource: resource}) do
    module = resource_module(resource)

    module
    |> Repo.get(id)
    |> Repo.preload(removed_pending_change: [:user, :reviewer])
    |> drop_ecto_fields()
    |> drop_nulls()
  end

  defp current_values(_) do
    %{}
  end

  defp determine_changes(changes, :create, _resource), do: changes
  defp determine_changes(changes, _, resource), do: Map.put(changes, "id", resource.id)

  defp drop_ecto_fields(schema) do
    schema
    |> Map.from_struct()
    |> Map.drop([:__meta__, :company, :industry, :inserted_at, :jobs, :updated_at])
  end

  defp drop_nulls(map) do
    Enum.reduce(map, %{}, fn
      {_k, nil}, acc -> acc
      {k, v}, acc -> Map.put(acc, k, v)
    end)
  end

  defp invalid_change(changes, action) do
    {:error, %{changes | repo: Repo, action: action}}
  end

  defp insert_change(%{data: resource, params: params} = change, :delete, user) when params == %{} do
    additions =
      Enum.reduce([:id, :name, :title], %{}, fn key, acc ->
        case Map.get(resource, key) do
          nil -> acc
          val -> Map.put(acc, to_string(key), val)
        end
      end)

    change
    |> Map.put(:params, additions)
    |> insert_change(:delete, user)
  end

  defp insert_change(%{data: resource, params: changes}, action, %{id: user_id} = user) do
    params = %{
      action: to_string(action),
      changes: determine_changes(changes, action, resource),
      resource: struct_to_string(resource),
      user_id: user_id
    }

    %PendingChange{}
    |> PendingChange.changeset(params)
    |> Repo.insert()
    |> notification(user)
  end

  @spec notification(term(), term()) :: {:ok, map()} | map()
  defp notification(result, user \\ nil)

  defp notification({:ok, pending_change}, nil) do
    %{user: user} = preloaded_change = Repo.preload(pending_change, [:user])
    notification({:ok, preloaded_change}, user)
  end

  defp notification({:ok, pending_change}, user) do
    pending_change
    |> Map.put(:user, user)
    |> Notify.perform()

    {:ok, pending_change}
  end

  defp notification(error, _user) do
    error
  end

  defp predicates(query, %{"approved" => approval}), do: query |> where([p], p.approved == ^approval)
  defp predicates(query, _), do: query |> where([p], is_nil(p.approved))

  defp resource_module("company"), do: Company
  defp resource_module("industry"), do: Industry
  defp resource_module("job"), do: Job

  defp struct_to_string(%Company{}), do: "company"
  defp struct_to_string(%Industry{}), do: "industry"
  defp struct_to_string(%Job{}), do: "job"

  defp update_approval(change, note, %{id: reviewer_id} = _reviewer, approval) do
    change
    |> PendingChange.approve_changeset(%{approved: approval, note: String.trim(note), reviewer_id: reviewer_id})
    |> Repo.update()
    |> notification()
  end
end
