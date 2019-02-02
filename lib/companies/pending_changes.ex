defmodule Companies.PendingChanges do
  @moduledoc """
  The public interface to managing our pending data changes
  """

  import Ecto.Query

  alias Companies.Repo
  alias Companies.Schema.{Company, Job, Industry, PendingChange}

  def all do
    query =
      from p in PendingChange,
        select: p,
        where: p.approved == false

    Repo.all(query)
  end

  def approve(change_id) do
    with %{action: action, changes: changes, resource: resource} = change <- Repo.get!(PendingChange, change_id),
         module <- resource_module(resource),
         changeset <- changeset(module, changes),
         {:ok, _changes} <- apply_changes(action, changeset) do
      change
      |> PendingChange.changeset(%{approved: true})
      |> Repo.update()
    else
      nil -> {:error, "change not found"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create(changeset, action, user, note \\ "")
  def create(%{valid?: false} = changes, action, _user, _note), do: invalid_change(changes, action)
  def create(changes, action, user, note), do: insert_change(changes, action, note, user)

  def get(id) do
    case Repo.get(PendingChange, id) do
      nil ->
        nil

      pending_change ->
        current = current_values(pending_change)
        %{pending_change | original: current}
    end
  end

  defp apply_changes("create", changeset), do: Repo.insert(changeset)
  defp apply_changes("update", changeset), do: Repo.update(changeset)

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

  defp current_values(%{changes: %{"id" => id}, resource: "company"}) do
    {%{id: industry_id}, current_values} =
      Company
      |> Repo.get(id)
      |> Repo.preload([:industry])
      |> drop_ecto_fields()
      |> Map.drop([:jobs])
      |> drop_nulls()
      |> Map.pop(:industry)

    Map.put(current_values, :industry_id, industry_id)
  end

  defp current_values(%{changes: %{"id" => id}, resource: resource}) do
    module = resource_module(resource)

    module
    |> Repo.get(id)
    |> drop_ecto_fields()
    |> drop_nulls()
  end

  defp current_values(_) do
    %{}
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

  defp insert_change(%{data: resource, params: changes}, action, note, %{id: user_id}) do
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
  end

  defp resource_module("company"), do: Company
  defp resource_module("industry"), do: Industry
  defp resource_module("job"), do: Job

  defp struct_to_string(%Company{}), do: "company"
  defp struct_to_string(%Industry{}), do: "industry"
  defp struct_to_string(%Job{}), do: "job"
end
