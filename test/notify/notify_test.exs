defmodule NotifyTest do
  use ExUnit.Case

  import ExUnit.CaptureLog

  describe "perform/1" do
    test "Uses the underlying notifier to notify" do
      assert capture_log(fn ->
               Notify.perform(%{action: :create, resource: "company", user: %{nickname: "doomspork"}})
             end) =~ "NOTIFICATION — %{action: :create, resource: \"company\", user: %{nickname: \"doomspork\"}}"
    end
  end
end
