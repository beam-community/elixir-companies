# lib/mix/tasks/create_company_file.ex
defmodule Mix.Tasks.CreateCompanyFile do
  use Mix.Task
  require Logger

  @shortdoc "Creates a company file in the priv/companies directory"

  @moduledoc """
  Generate company file in desired location and structure to render in UI

    $ mix create_company_file Acme Corp
    $ mix create_company_file "Acme Corp"
    $ mix create_company_file Acme   Corp
  """

  @impl Mix.Task
  @doc false
  def run(args) do
    case parse_args(args) do
      "" ->
        Logger.error("Expected at least one argument: the company name")
        Logger.info("Usage: mix create_company_file COMPANY_NAME")

      company_name ->
        maybe_create_file(company_name)
    end
  end

  defp parse_args(args) do
    args
    |> Enum.flat_map(&String.split(&1, ~r{\s}, trim: true))
    |> Enum.join(" ")
    |> String.trim()
  end

  defp maybe_create_file(company_name) do
    file_name = company_name |> String.replace(" ", "_") |> String.downcase()
    file_path = Path.join(["priv", "companies", "#{file_name}.exs"])

    if File.exists?(file_path) do
      Logger.error("Error: File already exists at #{file_path}")
      Logger.info("Please choose a different company name or alter the existing file.")
    else
      content = """
      # Company file for #{company_name}
      # Created on: #{Date.utc_today()}

      %{
        name: "#{company_name}",
        website: "https://example.com/",
        github: "https://github.com/example/#{file_name}",
        # reference lib/companies/industries.ex for a list of recommended industries to use here
        industry: "Technology",
        location: %{
          city: "City",
          state: "State",
          country: "Country"
        },
        description: \"\"\"
        Description of #{company_name} goes here.
        \"\"\",
        last_changed_on: ~D[#{Date.utc_today()}]
      }
      """

      case File.write(file_path, content) do
        :ok ->
          Logger.info("Company file created successfully: #{file_path}")

        {:error, reason} ->
          Logger.error("Failed to create company file: #{:file.format_error(reason)}")
      end
    end
  end
end
