defmodule RecordVerifier.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        RecordVerifier.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:record_verifier, :token_signing_secret)
  end
end
