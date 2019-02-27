defmodule Companies.Slack do
  use HTTPoison.Base

  def notify(%{action: action, resource: resource, user: %{nickname: nickname}}) do
    case notify_slack() do
      true -> post(endpoint(), message(action, resource, nickname))
      false -> nil
    end
  end

  def process_request_body(body) when is_map(body), do: Jason.encode!(body)
  def process_request_body(body), do: body

  def process_request_headers(headers), do: [{"Content-Type", "application/json"}] ++ headers

  def process_url(url), do: "https://hooks.slack.com/services/" <> url

  defp endpoint, do: System.get_env("SLACK_NOTIFICATION_ENDPOINT")

  defp message(action, resource, nickname) do
    %{
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
  end

  defp notify_slack(), do: Application.get_env(:companies, :notify_slack)
end
