defmodule CompaniesWeb.CompanyViewTest do
  use ExUnit.Case, async: true

  alias CompaniesWeb.CompanyView

  describe "markdown_format/1" do
    test "converts markdown to html" do
      assert {:safe, "<p><em>emphasis</em></p>\n"} == CompanyView.markdown_format("*emphasis*")
    end

    test "preserves allowed markdown html" do
      assert {:safe, "<p><b>bold</b></p>\n"} == CompanyView.markdown_format("<b>bold</b>")
    end

    test "removes disallowed html" do
      assert {:safe, "<p>bold</p>\n"} == CompanyView.markdown_format("<body onload=\"alert('hello')\">bold</body>")
    end
  end
end
