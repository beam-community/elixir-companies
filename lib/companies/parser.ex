defmodule Companies.Parser do
  def parse(path, contents) do
    dbg(path)

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
