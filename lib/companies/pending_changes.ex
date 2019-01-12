defmodule Companies.PendingChanges do
  @moduledoc """
  The public interface to managing our pending data changes
  """

  alias Companies.Repo
  alias Companies.Schema.{Company, Job, Industry, PendingChange}

  def all, do: Repo.all(PendingChange)

  def approve(change_id) do
    with %{action: action, changes: changes, resource: resource} = change <- Repo.get!(PendingChange, change_id),
         module <- resource_module(resource),
         complete_changes <- struct(module, changes),
         {:ok, _changes} <- apply_changes(action, complete_changes)
    do
      Repo.update!(%{change | approved: true})
    else
      nil -> {:error, "change not found"}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def create(changeset, action, user, note \\ "")
  def create(%{valid?: false} = changes, action, _user, _note), do: invalid_change(changes, action)
  def create(changes, action, user, note), do: insert_change(changes, action, note, user)

  defp apply_changes("delete", resource), do: Repo.delete(resource)
  defp apply_changes("insert", resource), do: Repo.insert(resource)
  defp apply_changes("update", resource), do: Repo.update(resource)

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
