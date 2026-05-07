defmodule RecordVerifier.Accounts.Role do
  @moduledoc """
  Resource for user current role
  """
  use Ash.Type.Enum, values: [:admin, :user]
end
