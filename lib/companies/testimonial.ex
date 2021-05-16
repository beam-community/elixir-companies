defmodule Companies.Testimonial do
  @moduledoc false

  defstruct [
    :body,
    :github,
    :job_title,
    :name,
    :twitter
  ]

  def build(_filename, attrs) do
    struct!(__MODULE__, attrs)
  end
end
