defmodule RecordVerifier.Enums.IdType do
  use Ash.Type.Enum,
    values: [
      "Voter's ID",
      "Voter's certification",
      "UMID ",
      "Postal ID",
      "Philhealth ID",
      "Pag-ibig ID",
      "National ID",
      "Senior Citizen's ID",
      "Passport",
      "Barangay ID",
      "Driver's License",
      "DSWD ID",
      "Barangay Certification",
      "Police Clearance",
      "NBI Clearance",
      "TIN ID",
      "SSS ID"
    ]
end
