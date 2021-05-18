defmodule CompaniesWeb.HTMLHelpers do
  use Phoenix.HTML

  def current_locale do
    Gettext.get_locale(CompaniesWeb.Gettext)
  end
end
