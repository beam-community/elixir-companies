defmodule Notify do
  def perform(message), do: apply(notifier(), :notify, [message])

  defp notifier, do: Application.get_env(:companies, :notifier)
end
