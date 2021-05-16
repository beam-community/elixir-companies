defmodule Companies.Testimonials do
  @moduledoc """
  Load our testimonials files and make them accessible to the UI
  """

  @testimonials (for file <- Path.wildcard("priv/testimonials/*.exs") do
                   {attrs, _bindings} = Code.eval_file(file)
                   Companies.Testimonial.build(file, attrs)
                 end)

  @doc """
  Return a random testimonial from our collection
  """
  def random do
    :random.seed(:os.timestamp())
    Enum.random(@testimonials)
  end
end
