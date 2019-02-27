defmodule Companies.PendingChanges do
  @moduledoc """
  The public interface to managing our pending data changes
  """

  import Ecto.Query

  alias Companies.{Repo, Slack}
  alias Companies.Schema.{Company, Job, Industry, PendingChange}

  def all do
    query = from p in PendingChange, where: p.approved == false

    Repo.all(query)
  end

  def get!(id) do
    Repo.get!(PendingChange, id)
  end

  def get(id) do
    case Repo.get(PendingChange, id) do
      nil ->
        nil

      pending_change ->
        pending_change = Repo.preload(pending_change, :user)
        current = current_values(pending_change)
        %{pending_change | original: current}
    end
  end

  def create(changeset, action, user, note \\ "")
  def create(%{valid?: false} = changes, action, _user, _note), do: invalid_change(changes, action)
  def create(changes, action, user, note), do: insert_change(changes, action, note, user)

  def act(change_id, "false") do
    PendingChange
    |> Repo.get!(change_id)
    |> Repo.delete!()

    {:ok, :rejected}
  end

  def act(change_id, "true") do
    change_id
    |> get!()
    |> modify_resource()
  end

  defp modify_resource(change = %{action: action, changes: changes, resource: resource}) do
    with module <- resource_module(resource),
         record <- get_record(module, changes),
         changeset <- apply_changeset(module, action, record, changes),
         {:ok, _changes} <- apply_changes(action, changeset) do
      change
      |> PendingChange.changeset(%{approved: true})
      |> Repo.update()
    else
      {:error, :module_not_recognized} -> {:error, :module_not_recognized}
      {:error, error} -> {:error, error}
    end
  end

  defp apply_changeset(_module, "delete", record, _changes) do
    record
  end

  defp apply_changeset(module, _action, record, changes) do
    module.changeset(record, changes)
  end

  defp get_record(module, changes) do
    if Map.has_key?(changes, "id") do
      id = Map.get(changes, "id")
      Repo.get(module, id)
    else
      struct(module, %{})
    end
  end

  defp current_values(%{changes: %{"id" => id}, resource: resource}) do
    resource
    |> resource_module()
    |> Repo.get(id)
    |> drop_relations()
    |> drop_ecto_fields()
    |> drop_nulls()
  end

  defp current_values(_) do
    %{}
  end

  defp insert_change(%{data: resource, params: changes}, action, note, %{id: user_id} = user) do
    updated_changes =
      case Map.get(resource, :id) do
        nil -> changes
        id -> Map.put(changes, "id", id)
      end

    params = %{
      action: to_string(action),
      changes: updated_changes,
      note: note,
      resource: struct_to_string(resource),
      user_id: user_id
    }

    %PendingChange{}
    |> PendingChange.changeset(params)
    |> Repo.insert()
    |> notify_slack(user)
  end

  defp drop_ecto_fields(schema) do
    schema
    |> Map.from_struct()
    |> Map.drop([:__meta__, :inserted_at, :updated_at])
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

  defp notify_slack({:ok, pending_change}, user) do
    pending_change
    |> Map.put(:user, user)
    |> Slack.notify()

    {:ok, pending_change}
  end

  defp notify_slack(error, _user) do
    error
  end

  defp apply_changes("create", changeset), do: Repo.insert(changeset)
  defp apply_changes("update", changeset), do: Repo.update(changeset)
  defp apply_changes("delete", record), do: Repo.delete(record)

  defp resource_module("company"), do: Company
  defp resource_module("industry"), do: Industry
  defp resource_module("job"), do: Job
  defp resource_module(_), do: {:error, :module_not_recognized}

  defp drop_relations(job = %Job{}), do: Map.drop(job, [:company])
  defp drop_relations(company = %Company{}), do: Map.drop(company, [:jobs, :industry])

  defp struct_to_string(%Company{}), do: "company"
  defp struct_to_string(%Industry{}), do: "industry"
  defp struct_to_string(%Job{}), do: "job"
end
