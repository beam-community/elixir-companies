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
    |> subject("Your changes have been approved")
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
    |> subject("Your changes need to be revisited")
    |> with_template(template_id)
  end

  @spec change_update_email(map()) :: Bamboo.Email.t()
  defp change_update_email(%{changes: changes, resource: resource, user: %{email: email, nickname: nickname}}) do
    new_email()
    |> to(email)
    |> from("noreply@elixir-companies.com")
    |> substitute("{{nickname}}", nickname)
    |> substitute("{{resource}}", resource)
    |> substitute("{{resource_name}}", resource_name(changes))
  end

  @spec resource_name(map()) :: String.t()
  defp resource_name(%{"name" => name}), do: name
  defp resource_name(%{"title" => title}), do: title
end
