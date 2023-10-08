defmodule Mix.Tasks.Test.Websites do
  use Mix.Task

  require Logger

  @shortdoc "Checks company site reachability"

  @moduledoc """
  Checks if company websites are reachable.

      $ mix test.websites
      $ mix test.websites --num-workers 10 --timeout 5000

  The number of workers defines how many companies will be checked in parallel.
  The timeout defines the timeout in ms passed on to the HTTP client.
  """

  @impl true
  @doc false
  def run(args) do
    {opts, args} = OptionParser.parse!(args, strict: [num_workers: :integer, timeout: :integer])
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
    |> summarize_results()
  end

  defp override_default(_key, _val1, val2), do: val2

  defp eval_company_file(filename) do
    filename
    |> Code.eval_file()
    |> elem(0)
  end

  defp check_company_website(%{website: website} = company, opts) do
    cond do
      is_nil(website) or "" == website ->
        Logger.info("#{company.name} has no website")
        {:error, company, :no_website}

      true ->
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

  defp summarize_results(results) do
    grouped_by_status = Enum.group_by(results, &elem(&1, 0), &Tuple.delete_at(&1, 0))

    case grouped_by_status[:error] do
      nil ->
        Logger.info("No issues detected")

      errors ->
        Logger.warn("There where #{length(errors)} unreachable websites:")

        errors
        |> Enum.each(fn {company, reason} ->
          Logger.warn("#{company.name} (#{company.website}) is unreachable because #{inspect(reason)}")
        end)
    end
  end
end
