defmodule RecordVerifier.Accounts.Changes.CapitalizeString do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    |> Ash.Changeset.before_action(fn changeset ->
      changes =
        [
          :first_name,
          :middle_name,
          :last_name,
          :barangay,
          :city_or_municipality,
          :province,
          :district,
          :place_of_issue,
          :occupation,
          :civil_status,
          :dependent
        ]
        |> Enum.map(fn attribute ->
          {
            attribute,
            changeset
            |> Ash.Changeset.get_attribute(attribute)
            |> String.split(" ", trim: true)
            |> Enum.map_join(" ", &String.capitalize/1)
          }
        end)

      changeset
      |> Ash.Changeset.force_change_attributes(changes)
    end)
  end

  @impl true
  def atomic(changeset, opts, context) do
    {:ok, change(changeset, opts, context)}
  end
end
