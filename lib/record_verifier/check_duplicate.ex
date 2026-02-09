defmodule RecordVerifier.CheckDuplicate do
  alias RecordVerifier.Accounts

  # TODO: check the first, middle, last. if match, save it in dup table
  def segregate_records(beneficiary) do
    %{"day" => day, "month" => month, "year" => year} =
      ~r/(?<day>\d{2})\/(?<month>\d{2})\/(?<year>\d{4})/
      |> Regex.named_captures(beneficiary["Birth date (DD/MM/YYYY)"])

    day = String.to_integer(day)
    month = String.to_integer(month)
    year = String.to_integer(year)

    spread_sheet_id = beneficiary["unique_identifier"]

    params = %{
      committer: beneficiary["committer"],
      spread_sheet_id: spread_sheet_id,
      first_name: beneficiary["First name"],
      middle_name: beneficiary["Middle name"],
      last_name: beneficiary["Last name"],
      birth_date: Date.new!(year, month, day),
      barangay: beneficiary["Barangay"],
      city_or_municipality: beneficiary["City/Municipality"],
      province: beneficiary["Province"],
      district: beneficiary["District"],
      id_type: beneficiary["ID type"],
      id_number: beneficiary["ID number"],
      place_of_issue: beneficiary["Place of Issue"],
      contact_number: "0" <> to_string(beneficiary["Contact number"]),
      beneficiary_type: beneficiary["Beneficiary type"],
      occupation: beneficiary["Occupation"],
      sex: String.capitalize(beneficiary["Sex"]),
      civil_status: String.capitalize(beneficiary["Civil status"]),
      age: beneficiary["Age"],
      monthly_income: Money.new("PHP", beneficiary["Ave Monthly Income"]),
      dependent: beneficiary["Dependent"],
      interested:
        yes_no_to_boolean(beneficiary["Interested in wage employment or self-employment?"]),
      skills_needed: yes_no_to_boolean(beneficiary["Skills Training Needed"])
    }

    case Accounts.create_beneficiary(params) do
      {:error,
       %Ash.Error.Invalid{
         errors: [
           %Ash.Error.Changes.InvalidAttribute{
             message: "Unique spread sheet ID already exists for this beneficiary"
           }
         ]
       }} ->
        :error

      {:error, _} ->
        :server_error

      {:ok, %Accounts.Beneficiary{spread_sheet_id: spread_sheet_id}} ->
        :ok
    end
  end

  @spec yes_no_to_boolean(String.t()) :: boolean()
  defp yes_no_to_boolean(input) do
    cond do
      String.downcase(input) === "no" -> false
      String.downcase(input) === "yes" -> true
    end
  end
end
