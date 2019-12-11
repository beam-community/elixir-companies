defmodule Notify.Console do
  @moduledoc """
  Module to print notifications to the console. Used in dev/test
  """

  require Logger

  def notify(message), do: Logger.info("NOTIFICATION — #{inspect(message)}")
end
