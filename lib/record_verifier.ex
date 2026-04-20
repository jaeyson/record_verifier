defmodule RecordVerifier do
  @moduledoc """
  RecordVerifier keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_x_auth_token, do: Application.get_env(:record_verifier, :runtime)[:x_auth_token]
end
