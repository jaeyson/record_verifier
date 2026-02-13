defmodule RecordVerifier.Enums.Occupation do
  use Ash.Type.Enum,
    values: [
      "Small Transport Driver",
      "Homebased Worker",
      "Laborer",
      "Vendor",
      "Crop Grower",
      "Fisherfolk",
      "Livestock/Poultry Raiser"
    ]
end
