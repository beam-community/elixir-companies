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
  def change_approved(change) do
    temp_id = System.get_env("SENDGRID_APPROVED_TEMPLATE_ID")

    new_email()
    |> to(details.recipient)
    |> from("noreply@elixir-companies.com")
    |> subject("Your changes need to be revisited")
    |> with_template(temp_id)
    # whatever fields we'd need
    |> add_dynamic_field(:handle, details.handle)
    |> add_dynamic_field(:resource, details.resource)
  end

  @doc """
  This function builds an email that informs a user that their attempted changes were rejected and provides the apppropriate course of a
  action to take to get the changes approved
  """
  @spec change_rejected(map()) :: Bamboo.Email.t()
  def change_rejected(change) do
    temp_id = System.get_env("SENDGRID_REJECTED_TEMPLATE_ID")

    details = change_details(change)

    new_email()
    |> to(details.recipient)
    |> from("noreply@elixir-companies.com")
    |> subject("Your changes need to be revisited")
    |> with_template(temp_id)
    # whatever fields we'd need
    |> add_dynamic_field(:handle, details.handle)
    |> add_dynamic_field(:resource, details.resource)
  end

  @doc false
  @spec change_details(map()) :: map()
  def change_details(change) do
    change_details = %{changer: "", resource: "", resource_name: "", recipient: ""}

    loaded_change =
      change
      |> Repo.preload(:user)

    named_details = %{change_details | changer: loaded_change.user.nickname, recipient: loaded_change.user.email}

    resourced_change

    case loaded_change.resource do
      "company" ->
        %{named_details | resource: "company"}

      "job" ->
        %{named_details | resource: "job"}

      "industry" ->
        %{named_details | resource: "industry"}
    end

    resourced_change
  end
end
