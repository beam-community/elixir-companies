defmodule CompaniesWeb.Admin.UserLive do
  @moduledoc false
  use Phoenix.LiveView, layout: {CompaniesWeb.LayoutView, "live.html"}

  alias CompaniesWeb.Admin.UserView
  alias Companies.Accounts

  alias CompaniesWeb.Router.Helpers, as: Routes

  def render(assigns) do
    Phoenix.View.render(UserView, "index.html", assigns)
  end

  def mount(params, session, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn -> Accounts.get(session["user_id"]) end)
      |> assign(
        user_id: session["user_id"],
        locale: params["locale"]
      )
      |> search(params)

    {:ok, socket, temporary_assigns: [users: []]}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("search", params, %{assigns: assigns} = socket) do
    socket =
      socket
      |> search(params)
      |> push_patch(to: Routes.live_path(socket, CompaniesWeb.Admin.UserLive, assigns.locale, params))

    {:noreply, socket}
  end

  def handle_event("toggle_admin", %{"id" => id}, %{assigns: assigns} = socket) do
    {id, ""} = Integer.parse(id)

    case assigns.current_user.id == id do
      false ->
        id
        |> Accounts.get!()
        |> Accounts.toggle_admin()

      true ->
        nil
    end

    socket = assign(socket, :users, Accounts.list_users(%{}))

    {:noreply, socket}
  end

  def handle_event("load_more", _, %{assigns: assigns} = socket) do
    page = assigns.page + 1

    if last_page?(assigns) do
      {:noreply, socket}
    else
      users = Accounts.list_users(%{"page" => page})

      {:noreply,
       socket
       |> assign(users: users)
       |> assign(page: page)
       |> assign(update: "append")
       |> push_patch(to: Routes.live_path(socket, CompaniesWeb.Admin.UserLive, assigns.locale))}
    end
  end

  defp search(socket, params) do
    users = Accounts.list_users(params)

    socket
    |> assign(
      users: users,
      page: 1,
      total_pages: users.total_pages,
      text: params["search"]["text"],
      admin_only: params["search"]["admin_only"],
      update: "replace"
    )
  end

  defp last_page?(assigns) do
    assigns.page >= assigns.total_pages
  end
end
