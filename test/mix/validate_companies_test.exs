defmodule Mix.Tasks.ValidateCompaniesTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  describe "run/1" do
    test "succeeds when companies are valid" do
      assert capture_io(fn ->
               assert :ok = Mix.Tasks.ValidateCompanies.run(["./test/support/fixtures/valid_company.exs"])
             end) =~ "✅ ./test/support/fixtures/valid_company.exs is valid"
    end

    test "fails with invalid company" do
      capture_io(fn ->
        assert_raise Mix.Error, fn ->
          Mix.Tasks.ValidateCompanies.run(["./test/support/fixtures/invalid_industry.exs"])
        end
      end) =~ "❌ ./test/support/fixtures/invalid_company.exs is invalid"
    end

    test "supports multiple files" do
      assert capture_io(fn ->
               assert_raise Mix.Error, fn ->
                 assert :ok =
                          Mix.Tasks.ValidateCompanies.run([
                            "./test/support/fixtures/valid_company.exs",
                            "./test/support/fixtures/invalid_industry.exs",
                            "./test/support/fixtures/missing_file.exs"
                          ])
               end
             end) =~
               "✅ ./test/support/fixtures/valid_company.exs is valid\n❌ ./test/support/fixtures/invalid_industry.exs is invalid:\n—> industry: is invalid\n❌ ./test/support/fixtures/missing_file.exs failed:"
    end
  end
end
