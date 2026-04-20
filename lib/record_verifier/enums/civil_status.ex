defmodule RecordVerifier.Enums.CivilStatus do
  use Ash.Type.Enum, values: ["Single", "Married", "Widowed"]
end
