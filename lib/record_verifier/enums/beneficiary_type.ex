defmodule RecordVerifier.Enums.BeneficiaryType do
  use Ash.Type.Enum,
    values: [
      "Underemployed/Self-employed",
      "Displaced workers due to calamity"
    ]
end
