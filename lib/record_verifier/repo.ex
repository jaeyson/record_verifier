defmodule RecordVerifier.Repo do
  use Ecto.Repo,
    otp_app: :record_verifier,
    adapter: Ecto.Adapters.Postgres
end
