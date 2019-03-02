defmodule Notify.ConsoleTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  alias Notify.Console

  describe "notify/1" do
    test "logs our message to info" do
      assert capture_log(fn ->
               Console.notify(%{action: :create, resource: "company", user: %{nickname: "doomspork"}})
             end) =~ "NOTIFICATION — %{action: :create, resource: \"company\", user: %{nickname: \"doomspork\"}}"
    end
  end
end
