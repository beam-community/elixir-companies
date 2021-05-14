defmodule Companies.Testimonials do
  @moduledoc false

  use NimblePublisher,
    build: Companies.Testimonial,
    from: "priv/testimonials/*.md",
    as: :testimonials


  @doc """
  Return a random testimonial from our collection
  """
  def random do
    :random.seed(:os.timestamp)
    Enum.random(@testimonials)
  end
end
