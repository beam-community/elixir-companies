defmodule Companies.Testimonial do
  @moduledoc false

  defstruct [
    :body,
    :github,
    :id,
    :job_title,
    :name,
    :twitter
  ]

  def build(filename, attrs) do
    slug = Path.basename(filename, ".exs")
    struct!(__MODULE__, Map.put(attrs, :id, slug))
  end
end
