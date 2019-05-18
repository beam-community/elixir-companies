defmodule CompaniesWeb.CompanyLive do
  use Phoenix.LiveView

  def mount(_session, socket) do
    industries = Companies.Industries.all()
    companies = Companies.Companies.all()
    {:ok,
     assign(socket, %{
       search: %{
         industry_id: nil,
         only_hiring: false,
         search_text: ""
       },
       companies: companies,
       industries: industries
     })}
  end

  def render(assigns) do
    CompaniesWeb.LiveView.render("browse.html", assigns)
  end
end
