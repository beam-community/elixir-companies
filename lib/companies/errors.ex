defmodule Companies.NotFoundError do
  defexception message: "resource not found"
end

defimpl Plug.Exception, for: Companies.NotFoundError do
  def status(_exception), do: 404
  def actions(_exception), do: []
end
