defmodule Mix.Tasks.ValidateCompanyFile do
  use Mix.Task

  alias Companies.Industries
  alias Companies.Schema.Company

  def run([file_path]) do
    case File.read(file_path) do
      {:ok, content} ->
        IO.puts("Validating #{file_path}")

        {company, _binding} = Code.eval_string(content)

        if Company.validate_industries(company) do
          IO.puts("Company is valid")
        else
          Mix.raise("""
          Invalid industry. Please use one of the following:

          #{Enum.join(Industries.all(), ", ")}
          """)
        end

      {:error, reason} ->
        Mix.raise("Could not read #{file_path}: #{reason}")
    end
  end
end
