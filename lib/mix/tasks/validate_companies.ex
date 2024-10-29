defmodule Mix.Tasks.ValidateCompanies do
  use Mix.Task

  alias Companies.Schema.Company

  @moduledoc """
  Validates a filepath to a company.

      $ mix validate_companies priv/companies/abc.exs

  This is to help with data consistency.
  """

  @impl Mix.Task
  @doc false
  def run(file_paths) do
    result =
      Enum.reduce(file_paths, :ok, fn file_path, acc ->
        validation = validate_company(file_path)

        cond do
          acc == :error ->
            :error

          validation == :error ->
            :error

          true ->
            :ok
        end
      end)

    with :error <- result do
      Mix.raise("Validation failed")
    end
  end

  def validate_company(file_path) do
    with {:ok, content} <- File.read(file_path),
         {company, _binding} <- Code.eval_string(content),
         %Ecto.Changeset{valid?: true} <- Company.changeset(company) do
      IO.puts("✅ #{file_path} is valid")
      :ok
    else
      %Ecto.Changeset{} = changeset ->
        errors = display_errors(changeset)

        IO.puts("❌ #{file_path} is invalid:\n#{errors}")
        :error

      {:error, reason} ->
        IO.puts("❌ #{file_path} failed: #{reason}")
        :error

      _ ->
        :error
    end
  end

  def display_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&translate_error/1)
    |> Enum.reduce([], fn {key, [value]}, acc ->
      ["—> #{key}: #{value}" | acc]
    end)
    |> Enum.join("\n")
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", fn _ -> to_string(value) end)
    end)
  end
end
