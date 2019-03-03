defmodule Notify.SlackTest do
  use ExUnit.Case

  alias Notify.Slack

  setup do
    {:ok, bypass: Bypass.open()}
  end

  describe "notify/1" do
    test "triggers a Slack notification", %{bypass: bypass} do
      System.put_env("SLACK_NOTIFICATION_ENDPOINT", "example,test")
      Bypass.expect(bypass, "POST", "/example", &slack_success/1)
      Bypass.expect(bypass, "POST", "/test", &slack_success/1)
      bypass_url = "http://localhost:#{bypass.port}/"

      Slack.notify(%{action: :create, resource: "company", user: %{nickname: "doomspork"}}, base_url: bypass_url)
    end

    defp slack_success(conn), do: Plug.Conn.resp(conn, 200, "{}")
  end
end
