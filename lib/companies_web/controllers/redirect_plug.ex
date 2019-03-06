defmodule CompaniesWeb.Redirect do
  @moduledoc """
  A plug used to handle redirects by the `CompaniesWeb.Router`
  """
  import Plug.Conn

  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt()
  end
end
