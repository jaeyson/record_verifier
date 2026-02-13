defmodule RecordVerifierWeb.Plugs.CheckAuthToken do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    server_token = RecordVerifier.get_x_auth_token()

    case get_req_header(conn, "x-auth-token") do
      [^server_token] ->
        conn

      _ ->
        conn
        |> send_resp(Plug.Conn.Status.code(:forbidden), "Forbidden")
        |> halt()
    end
  end
end
