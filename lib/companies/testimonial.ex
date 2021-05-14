defmodule Companies.Testimonial do
  @moduledoc false

  @enforce_keys [:job_title, :name]
  defstruct [
    :body,
    :github,
    :job_title,
    :name,
    :twitter
  ]

  def build(_filename, attrs, body) do
    # slice off `<p>` and `</p>\n`
    struct!(__MODULE__, [body: String.slice(body, 3..-6)] ++ Map.to_list(attrs))
  end
end
