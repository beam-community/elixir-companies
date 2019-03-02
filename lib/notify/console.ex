defmodule Notify.Console do
  require Logger

  def notify(message), do: Logger.info("NOTIFICATION — #{inspect(message)}")
end
