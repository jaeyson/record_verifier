defmodule RecordVerifier.Accounts do
  use Ash.Domain,
    otp_app: :record_verifier

  resources do
    resource RecordVerifier.Accounts.Token
    resource RecordVerifier.Accounts.User
  end
end
