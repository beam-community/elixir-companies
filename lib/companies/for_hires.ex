defmodule Companies.ForHires do
  @moduledoc """
  Load developers available for hire
  """

  @for_hires (for file <- Path.wildcard("priv/for_hire/*.exs") do
                {attrs, _bindings} = Code.eval_file(file)
                Companies.ForHire.build(file, attrs)
              end)

  @doc """
  Return a random testimonial from our collection
  """
  def all do
    Enum.shuffle(@for_hires)
  end
end
