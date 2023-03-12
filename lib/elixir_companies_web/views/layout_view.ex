defmodule ElixirCompaniesWeb.LayoutView do
  use ElixirCompaniesWeb, :view

  def current_location do
    ElixirCompaniesWeb.Gettext
    |> Gettext.get_locale()
    |> String.capitalize()
  end

  def known_locales, do: Gettext.known_locales(ElixirCompaniesWeb.Gettext)
end
