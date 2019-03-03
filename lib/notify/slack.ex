defmodule Notify.Slack do
  use HTTPoison.Base

  def notify(%{action: action, resource: resource, user: %{nickname: nickname}}, opts \\ []) do
    message = %{
      attachments: [
        %{
          color: "#7CD197",
          fields: [
            %{short: true, title: "Action", value: action},
            %{short: true, title: "Resource", value: resource},
            %{title: "User", value: nickname}
          ]
        }
      ]
    }

    opts
    |> urls()
    |> Enum.each(&post(&1, message))
  end

  def process_request_body(body) when is_map(body), do: Jason.encode!(body)
  def process_request_body(body), do: body

  def process_request_headers(headers), do: [{"Content-Type", "application/json"}] ++ headers

  def urls(opts) do
    base_url = Keyword.get(opts, :base_url, "https://hooks.slack.com/services/")
    Enum.map(endpoints(), &Path.join(base_url, &1))
  end

  defp endpoints do
    "SLACK_NOTIFICATION_ENDPOINT"
    |> System.get_env()
    |> String.split(",", trim: true)
  end
end
