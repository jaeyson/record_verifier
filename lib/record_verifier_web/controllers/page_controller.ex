defmodule RecordVerifierWeb.PageController do
  alias RecordVerifier.CheckDuplicate
  use RecordVerifierWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def verify(conn, %{"_json" => beneficiaries} = params) do
    payload =
      beneficiaries
      |> Enum.map(&CheckDuplicate.segregate_records/1)
      |> IO.inspect(label: "map")

    conn
    |> put_status(:created)
    |> json(payload)
  end
end
