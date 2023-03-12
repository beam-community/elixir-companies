defmodule ElixirCompanies.URLSchemerTest do
  use ExUnit.Case

  alias ElixirCompanies.URLSchemer

  test "url_with_scheme/1 returns the same url if it already has http" do
    url = "http://test.com"
    assert url == URLSchemer.url_with_scheme(url)
  end

  test "url_with_scheme/1 returns the same url if it already has https" do
    url = "https://test.com"
    assert url == URLSchemer.url_with_scheme(url)
  end

  test "url_with_scheme/2 returns the url with https if it doesn't not have it (one arg / default)" do
    url = "test.com"
    assert "https://" <> url == URLSchemer.url_with_scheme(url)
  end

  test "url_with_scheme/2 returns the url with http/https if it doesn't have it (two args / provided)" do
    url = "test.com"
    assert "https://" <> url == URLSchemer.url_with_scheme(url, "https")
    assert "http://" <> url == URLSchemer.url_with_scheme(url, "http")
  end
end
