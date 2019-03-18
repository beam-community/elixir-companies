defmodule CompaniesWeb.LayoutView do
  use CompaniesWeb, :view

  def current_location do
    CompaniesWeb.Gettext
    |> Gettext.get_locale()
    |> String.capitalize()
  end

  def known_locales do
    Gettext.known_locales(CompaniesWeb.Gettext)
  end
end
