defmodule Mix.Tasks.Test.Websites do
  use Mix.Task

  require Logger

  @shortdoc "Checks company site reachability"

  @moduledoc """
  Checks if company websites are reachable.

      $ mix test.websites
      $ mix test.websites --num-workers 10 --timeout 5000 --github-token ghp_... priv/companies/abc.exs

  The number of workers defines how many companies will be checked in parallel.
  The timeout defines the timeout in ms passed on to the HTTP client.
  An optional github token can be passed to get the updated_at field of the github org

  Optionally a list of files can be passed - in that case only those files will be checked
  """

  @impl true
  @doc false
  def run(args) do
    {opts, args} = OptionParser.parse!(args, strict: [num_workers: :integer, timeout: :integer, github_token: :string])
    opts = Keyword.merge([num_workers: 30, timeout: 1000], opts, &override_default/3)

    Application.ensure_all_started(:companies)
    companies_directory = Application.get_env(:companies, :companies_directory)

    files =
      case args do
        [] ->
          Path.wildcard(companies_directory)

        input_files ->
          Logger.info("Checking #{length(input_files)} files")
          input_files
      end

    files
    |> Enum.map(&eval_company_file/1)
    |> ParallelStream.map(&check_company_website(&1, opts), num_workers: Keyword.fetch!(opts, :num_workers))
    |> summarize_results(opts)
  end

  defp override_default(_key, _val1, val2), do: val2

  defp eval_company_file(filename) do
    filename
    |> Code.eval_file()
    |> elem(0)
  end

  defp check_company_website(%{website: website} = company, opts) do
    if is_nil(website) or "" == website do
      Logger.info("#{company.name} has no website")
      {:error, company, :no_website}
    else
      check_website(company, opts)
    end
  end

  defp check_website(%{website: website} = company, opts) do
    case HTTPoison.get(website, [], timeout: Keyword.fetch!(opts, :timeout)) do
      {:ok, _} ->
        {:ok, company}

      {:error, reason} ->
        {:error, company, reason}
    end
  end

  defp summarize_results(results, opts) do
    grouped_by_status = Enum.group_by(results, &elem(&1, 0), &Tuple.delete_at(&1, 0))

    case grouped_by_status[:error] do
      nil ->
        Logger.info("No issues detected")

      errors ->
        Logger.warn("There where #{length(errors)} unreachable websites:")

        errors
        |> Enum.each(fn {company, reason} ->
          last_activity = maybe_get_last_activity(company, opts)

          Logger.warn(
            "#{company.name} (#{company.website}, #{company.github}#{last_activity}) is unreachable because #{inspect(reason)}"
          )
        end)
    end
  end

  defp maybe_get_last_activity(company, opts) do
    if company.github != "" && Keyword.has_key?(opts, :github_token) do
      github_org = company.github |> String.trim_trailing("/") |> String.split("/") |> List.last()

      Logger.debug("Getting activity for #{github_org}")

      %{body: body} =
        HTTPoison.get!("https://api.github.com/orgs/#{github_org}", [
          {"Authorization", "bearer #{Keyword.fetch!(opts, :github_token)}"}
        ])

      case Jason.decode!(body) do
        %{"updated_at" => updated_at} -> " - #{updated_at}"
        _ -> " - unknown"
      end
    else
      ""
    end
  end
end
