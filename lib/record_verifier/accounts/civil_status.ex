defmodule RecordVerifier.Accounts.CivilStatus do
  use Ash.Type.Enum, values: ["Single", "Married", "Widowed"]
end
