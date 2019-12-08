defmodule Companies.EmailEvents do
  @moduledoc """
  Tracking email lifecycle events from SendGrid

  https://sendgrid.com/docs/for-developers/tracking-events/
  """

  alias Companies.Schema.{EmailEvent, User}
  alias Companies.{Accounts, Repo, TaskSupervisor}

  @disable_user_emails ["bounce", "spamreport", "unsubscribe"]
  @whitelisted_events ["delivered", "open"]

  def create(events) do
    Task.Supervisor.start_child(TaskSupervisor, fn ->
      Enum.each(events, &create_event/1)
    end)
  end

  defp create_event(%{"email" => user_email, "event" => event} = params) do
    with true <- watched_event?(event),
         %User{} = user <- Accounts.get_by_email(user_email),
         {:ok, _event} <- store_event(params, user),
         {:ok, _user} <- update_user_preferences(event, user) do
      :ok
    else
      false ->
        :ok

      {:error, %{errors: errors}} ->
        send_error(errors, params)
    end
  end

  defp send_error(errors, params) do
    Appsignal.send_error(%RuntimeError{}, "SendGrid Callback", [], %{params: params, errors: errors})
  end

  defp store_event(params, %{id: user_id}) do
    updated_params = Map.put(params, "user_id", user_id)

    %EmailEvent{}
    |> EmailEvent.changeset(updated_params)
    |> Repo.insert()
  end

  defp update_user_preferences(_event, %{email_notifications: false} = user),
    do: {:ok, user}

  defp update_user_preferences(event, user) when event in @disable_user_emails,
    do: Accounts.update(user, %{email_notifications: false})

  defp update_user_preferences(_event, user),
    do: {:ok, user}

  defp watched_event?(event), do: event in (@disable_user_emails ++ @whitelisted_events)
end
