defmodule Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  # embedded_schema since it's not persisting to DB
  embedded_schema do
    field :number, :string
    field :customer, :string
    field :amount, :decimal
    field :due_date, :string
    field :status, :string
  end

  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:customer, :amount])
    |> validate_required([:customer])
    |> validate_required([:amount])
    |> validate_length(:customer, min: 2, max: 100)
    |> validate_number(:amount, greater_than: 1000)
  end
end
