defmodule RecordVerifier.Accounts.Gender do
  use Ash.Type.Enum, values: ["Male", "Female"]
end
