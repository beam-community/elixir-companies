defmodule Companies.Parser do
  @moduledoc """
  Custom NimblePublisher Parser for support *.exs files
  """

  def parse(path, contents) do
    id =
      path
      |> Path.rootname()
      |> Path.split()
      |> List.last()

    attrs =
      contents
      |> Code.eval_string()
      |> elem(0)
      |> Map.put(:id, id)

    {attrs, ""}
  end
end
