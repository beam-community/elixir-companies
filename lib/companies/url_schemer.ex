defmodule Companies.URLSchemer do
  @moduledoc """
  URLSchemer module to make sure a given external url
  has http / https on it.
  """
  def url_with_scheme("http://" <> _ = url), do: url
  def url_with_scheme("https://" <> _ = url), do: url
  def url_with_scheme(url, scheme \\ "https"), do: "#{scheme}://#{url}"
end
