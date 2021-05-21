template = ~S/%{
  blog: "<%= company.blog %>",
  date_added: ~D[<%= NaiveDateTime.to_date(company.inserted_at) %>],
  github: "<%= company.github %>",
  industries: ["<%= company.industry.name %>"],
  locations: ["<%= company.location %>"],
  name: "<%= company.name %>",
  old_id: <%= company.id %>,
  url: "<%= company.url %>",
  description: """
  <%= String.trim(company.description) %>
  """
}
/

import Ecto.Query

query =
  from(c in Companies.Schema.Company,
    join: i in assoc(c, :industry),
    preload: [industry: i]
  )

for company <- Companies.Repo.all(query) do
  filename =
    company.name
    |> String.replace(~r/[^\w]/, "")
    |> String.downcase()

  contents = EEx.eval_string(template, company: company)
  File.write!("priv/companies/#{filename}.exs", contents)
end
