defmodule Notify do
  @moduledoc """
  Context module that handles the sending of actual notifications 
  """
  alias Notify.{Email, Mailer}

  @doc false
  @spec perform(map()) :: Bamboo.Email.t() | term()
  def perform(%{approved: true} = pending_change) do
    pending_change
    |> Email.change_approved()
    |> Mailer.deliver_now()
  end

  def perform(%{approved: false} = pending_change) do
    pending_change
    |> Email.change_rejected()
    |> Mailer.deliver_now()
  end

  def perform(message), do: apply(notifier(), :notify, [message])

  defp notifier, do: Application.get_env(:companies, :notifier)
end
