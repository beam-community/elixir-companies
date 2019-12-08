defmodule Notify.Email do
  @moduledoc """
  This module holds the email notification functionality we use when updating users of various occurences in the system
  """
  import Bamboo.Email
  import Bamboo.SendGridHelper

  @doc """
  This function builds an email that informs a user of their attempted changes being approved and applied
  """
  @spec change_approved(map()) :: Bamboo.Email.t()
  def change_approved(pending_change) do
    template_id = System.get_env("SENDGRID_APPROVED_TEMPLATE_ID")

    pending_change
    |> change_update_email()
    |> subject("Your Elixir Companies change was approved")
    |> with_template(template_id)
  end

  @doc """
  This function builds an email that informs a user that their attempted changes were rejected and provides the apppropriate course of a
  action to take to get the changes approved
  """
  @spec change_rejected(map()) :: Bamboo.Email.t()
  def change_rejected(pending_change) do
    template_id = System.get_env("SENDGRID_REJECTED_TEMPLATE_ID")

    pending_change
    |> change_update_email()
    |> subject("Your Elixir Companies change needs to be revisited")
    |> with_template(template_id)
  end

  defp change_update_email(%{changes: changes, note: note, resource: resource, user: user}) do
    %{email: email, nickname: nickname} = user

    new_email()
    |> to(email)
    |> from("noreply@elixir-companies.com")
    |> add_dynamic_field("nickname", nickname)
    |> add_dynamic_field("note", note)
    |> add_dynamic_field("resource", resource)
    |> add_dynamic_field("resource_name", resource_name(changes))
  end

  defp resource_name(%{"name" => name}), do: name
  defp resource_name(%{"title" => title}), do: title
end
