defmodule Companies.EmailEvents do
  @moduledoc """
  Tracking email lifecycle events from SendGrid

  https://sendgrid.com/docs/for-developers/tracking-events/
  """

  alias Companies.{Accounts, Repo, Schemas.EmailEvent}

  @disable_user_emails ["bounce", "spamreport", "unsubscribe"]
  @whitelisted_events ["delivered", "open"]

  def create(events) do
    Task.start(fn ->
      Enum.reduce(events, %{}, &create_event/2)
    end)
  end

  defp create_event(%{"email" => user_email, "event" => event} = attrs, acc) do
    if event in (@disable_user_emails ++ @whitelisted_events) do
      user = Map.get(acc, user_email) || Accounts.get_user_by_email(user_email)

      store_event(attrs, user)

      updated_user =
        case update_user_preferences(event, user) do
          {:ok, updated_user} -> updated_user
          _ -> user
        end

      Map.put(acc, user_email, updated_user)
    else
      acc
    end
  end

  defp store_event(attrs, %{id: user_id}) do
    updated_attrs = Map.put(attrs, "user_id", user_id)

    %EmailEvent{}
    |> EmailEvent.changeset(updated_attrs)
    |> Repo.insert()
  end

  defp update_user_preferences(_event, %{email_notifications: false} = user),
    do: {:ok, user}

  defp update_user_preferences(event, user) when event in @disable_user_emails,
    do: Accounts.update(user, %{email_notifications: false})

  defp update_user_preferences(_event, user),
    do: {:ok, user}
end
