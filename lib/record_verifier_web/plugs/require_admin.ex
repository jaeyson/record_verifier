defmodule RecordVerifierWeb.Plugs.RequireAdmin do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    current_user = conn.assigns[:current_user]

    if current_user && current_user.role == :admin do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end
  end
end
