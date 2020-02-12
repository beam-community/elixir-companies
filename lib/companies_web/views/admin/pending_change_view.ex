defmodule CompaniesWeb.Admin.PendingChangeView do
  use CompaniesWeb, :view

  import Scrivener.HTML

  def github_user_link(%{nickname: nickname}) do
    link(
      nickname,
      to: "https://github.com/#{nickname}",
      target: "_blank"
    )
  end

  def to_json(map) do
    Jason.encode!(map, pretty: true)
  end

  def pending_change_title(%{approved: nil}), do: gettext("Pending Change")
  def pending_change_title(%{approved: true}), do: gettext("Approved Change")
  def pending_change_title(%{approved: false}), do: gettext("Rejected Change")

  def pending_changes_title(%{params: %{"approved" => "true"}}), do: gettext("Approved Changes")
  def pending_changes_title(%{params: %{"approved" => "false"}}), do: gettext("Rejected Changes")
  def pending_changes_title(_), do: gettext("Pending Changes")

  def pending_approval?(%{approved: nil}), do: true
  def pending_approval?(_), do: false

  def active_tab?(params, page) do
    case current_page_from_params(params) == page do
      true -> "is-active"
      false -> ""
    end
  end

  defp current_page_from_params(%{"approved" => "true"}), do: :approved
  defp current_page_from_params(%{"approved" => "false"}), do: :unapproved
  defp current_page_from_params(_), do: :pending
end
