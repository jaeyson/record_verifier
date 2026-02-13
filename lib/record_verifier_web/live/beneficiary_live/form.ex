defmodule RecordVerifierWeb.BeneficiaryLive.Form do
  use RecordVerifierWeb, :live_view
  alias Phoenix.LiveView.ColocatedHook

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage beneficiary records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="beneficiary-form"
        phx-change="validate"
        phx-submit="save"
        class="max-w-5xl mx-auto"
      >
        <%= if @form.source.type == :create do %>
          <.input field={@form[:committer]} type="text" label="Committer" /><.input
            field={@form[:spread_sheet_id]}
            type="text"
            label="Spread sheet"
          /><.input field={@form[:first_name]} type="text" label="First name" /><.input
            field={@form[:middle_name]}
            type="text"
            label="Middle name"
          /><.input field={@form[:last_name]} type="text" label="Last name" /><.input
            field={@form[:birth_date]}
            type="date"
            label="Birth date"
          /><.input field={@form[:barangay]} type="select" label="Barangay" /><.input
            field={@form[:city_or_municipality]}
            type="text"
            label="City or municipality"
          /><.input field={@form[:province]} type="text" label="Province" /><.input
            field={@form[:district]}
            type="text"
            label="District"
          /><.input field={@form[:id_type]} type="text" label="Id type" /><.input
            field={@form[:id_number]}
            type="text"
            label="Id number"
          /><.input field={@form[:place_of_issue]} type="text" label="Place of issue" /><.input
            field={@form[:contact_number]}
            type="text"
            label="Contact number"
          /><.input field={@form[:beneficiary_type]} type="text" label="Beneficiary type" /><.input
            field={@form[:occupation]}
            type="text"
            label="Occupation"
          /><.input field={@form[:sex]} type="text" label="Sex" /><.input
            field={@form[:civil_status]}
            type="text"
            label="Civil status"
          /><.input field={@form[:age]} type="number" label="Age" /><.input
            field={@form[:monthly_income]}
            type="text"
            label="Monthly income"
          /><.input field={@form[:dependent]} type="text" label="Dependent" /><.input
            field={@form[:interested]}
            type="checkbox"
            label="Interested"
          /><.input field={@form[:skills_needed]} type="checkbox" label="Skills needed" />
        <% end %>
        <%= if @form.source.type == :update do %>
          <.input
            field={@form[:first_name]}
            type="text"
            label="First name"
          />
          <.input
            field={@form[:middle_name]}
            type="text"
            label="Middle name"
          />
          <.input
            field={@form[:last_name]}
            type="text"
            label="Last name"
          />
          <.input
            id="birth-date-input"
            field={@form[:birth_date]}
            type="date"
            label="Birth date (MM/DD/YYYY)"
            phx-hook=".CalculateAge"
          />
          <.input
            field={@form[:barangay]}
            type="select"
            label="Barangay"
            options={RecordVerifier.Enums.Barangay.values()}
          />
          <.input
            field={@form[:city_or_municipality]}
            type="select"
            label="City or municipality"
            options={RecordVerifier.Enums.CityOrMunicipality.values()}
          />
          <.input
            field={@form[:province]}
            type="text"
            label="Province"
          />
          <.input
            field={@form[:district]}
            type="text"
            label="District"
          />
          <.input
            field={@form[:id_type]}
            type="select"
            label="Id type"
            options={RecordVerifier.Enums.IdType.values()}
          />
          <.input
            field={@form[:id_number]}
            type="text"
            label="Id number"
          />
          <.input
            field={@form[:place_of_issue]}
            type="text"
            label="Place of issue"
          />
          <.input
            field={@form[:contact_number]}
            type="text"
            label="Contact number"
          />
          <.input
            field={@form[:beneficiary_type]}
            type="select"
            label="Beneficiary type"
            options={RecordVerifier.Enums.BeneficiaryType.values()}
          />
          <.input
            field={@form[:occupation]}
            type="select"
            label="Occupation"
            options={RecordVerifier.Enums.Occupation.values()}
          />
          <.input
            field={@form[:sex]}
            type="select"
            label="Sex"
            options={RecordVerifier.Enums.Sex.values()}
          />
          <.input
            field={@form[:civil_status]}
            type="text"
            label="Civil status"
            options={RecordVerifier.Enums.CivilStatus.values()}
          />
          <.input
            id="age-input"
            field={@form[:age]}
            type="number"
            label="Age"
            disabled
            readonly
          />
          <.input
            field={@form[:monthly_income]}
            type="text"
            label="Monthly income"
          />
          <.input
            field={@form[:dependent]}
            type="text"
            label="Dependent"
          />
          <.input
            field={@form[:interested]}
            type="checkbox"
            label="Interested"
          />
          <.input
            field={@form[:skills_needed]}
            type="checkbox"
            label="Skills needed"
          />
        <% end %>

        <.button phx-disable-with="Saving..." variant="primary">Save Beneficiary</.button>
        <.button navigate={return_path(@return_to, @beneficiary)}>Cancel</.button>
      </.form>
    </Layouts.app>
    <script :type={ColocatedHook} name=".CalculateAge">
      export default {
        mounted() {
          this.el.addEventListener("input", e => {
            const birthDate = new Date(e.target.value);
            const ageInput = document.getElementById("age-input");

            if (birthDate) {
              const today = new Date();
              let age = today.getFullYear() - birthDate.getFullYear();
              const monthDiff = today.getMonth() - birthDate.getMonth();
              
              // Adjust age if birthday hasn't occurred yet this year
              if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
              }

              if (!isNaN(age) && age >= 0) {
                ageInput.value = age;
                // Important: Manually dispatch a change event so Phoenix 
                // knows the value changed if you're using phx-change on the form
                ageInput.dispatchEvent(new Event("input", {bubbles: true}));
              }
            }
          })
        }
      }
    </script>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    beneficiary =
      case params["id"] do
        nil ->
          nil

        id ->
          Ash.get!(RecordVerifier.Accounts.Beneficiary, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(beneficiary), do: "New", else: "Edit"
    page_title = action <> " " <> "Beneficiary"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(beneficiary: beneficiary)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"beneficiary" => beneficiary_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, beneficiary_params))}
  end

  def handle_event("save", %{"beneficiary" => beneficiary_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: beneficiary_params) do
      {:ok, beneficiary} ->
        notify_parent({:saved, beneficiary})

        socket =
          socket
          |> put_flash(:info, "Beneficiary #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, beneficiary))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{beneficiary: beneficiary}} = socket) do
    form =
      if beneficiary do
        AshPhoenix.Form.for_update(beneficiary, :update,
          as: "beneficiary",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(RecordVerifier.Accounts.Beneficiary, :create,
          as: "beneficiary",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _beneficiary), do: ~p"/beneficiaries"
  defp return_path("show", beneficiary), do: ~p"/beneficiaries/#{beneficiary.id}"
end
