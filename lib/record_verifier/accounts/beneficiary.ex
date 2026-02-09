defmodule RecordVerifier.Accounts.Beneficiary do
  use Ash.Resource,
    otp_app: :record_verifier,
    domain: RecordVerifier.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    data_layer: AshPostgres.DataLayer

  postgres do
    table "beneficiaries"
    repo RecordVerifier.Repo
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      accept [
        :committer,
        :spread_sheet_id,
        :first_name,
        :middle_name,
        :last_name,
        :birth_date,
        :barangay,
        :city_or_municipality,
        :province,
        :district,
        :id_type,
        :id_number,
        :place_of_issue,
        :contact_number,
        :beneficiary_type,
        :occupation,
        :sex,
        :civil_status,
        :age,
        :monthly_income,
        :dependent,
        :interested,
        :skills_needed
      ]
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if always()
    end

    policy action_type(:destroy) do
      authorize_if always()
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :committer, :string do
      allow_nil? false
    end

    attribute :spread_sheet_id, :string do
    end

    attribute :first_name, :string do
      allow_nil? false
    end

    attribute :middle_name, :string do
      allow_nil? false
    end

    attribute :last_name, :string do
      allow_nil? false
    end

    attribute :birth_date, :date do
      allow_nil? false
      description "Birth date (DD/MM/YYYY)"
    end

    attribute :barangay, :string do
      allow_nil? false
    end

    attribute :city_or_municipality, :string do
      allow_nil? false
    end

    attribute :province, :string do
      allow_nil? false
    end

    attribute :district, :string do
      allow_nil? false
    end

    attribute :id_type, :string do
      allow_nil? false
    end

    attribute :id_number, :string do
      allow_nil? false
    end

    attribute :place_of_issue, :string do
      allow_nil? false
    end

    attribute :contact_number, :string do
      allow_nil? false
    end

    attribute :beneficiary_type, :string do
      allow_nil? false
    end

    attribute :occupation, :string do
      allow_nil? false
    end

    attribute :sex, RecordVerifier.Accounts.Gender do
      allow_nil? false
    end

    attribute :civil_status, RecordVerifier.Accounts.CivilStatus do
      allow_nil? false
    end

    attribute :age, :integer do
      allow_nil? false
    end

    attribute :monthly_income, :money do
      allow_nil? false
    end

    attribute :dependent, :string do
      allow_nil? false
    end

    attribute :interested, :boolean do
      allow_nil? false
    end

    attribute :skills_needed, :boolean do
      allow_nil? false
    end

    timestamps()
  end

  identities do
    # identity :unique_id_number_per_beneficiary, [:id_number],
    #   message: "already exists for this beneficiary"

    identity :unique_spread_sheet_id_per_beneficiary, [:spread_sheet_id],
      message: "Unique spread sheet ID already exists for this beneficiary"

    identity :unique_combination_of_names_per_beneficiary,
             [:first_name, :middle_name, :last_name],
             message: "Full name already exists for this beneficiary"
  end
end
