defmodule RecordVerifier.Accounts do
  use Ash.Domain, otp_app: :record_verifier, extensions: [AshAdmin.Domain, AshPhoenix]

  admin do
    show? true
  end

  resources do
    resource RecordVerifier.Accounts.Token
    resource RecordVerifier.Accounts.User

    resource RecordVerifier.Accounts.Beneficiary do
      define :create_beneficiary, action: :create
      define :list_beneficiaries, action: :read
      define :get_beneficiary, action: :read, get_by: :id
      define :change_beneficiary, action: :update
    end
  end
end
