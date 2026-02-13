defmodule RecordVerifierWeb.Beneficiaries.IndexLive do
  use RecordVerifierWeb, :live_view
  alias RecordVerifierWeb.Beneficiaries
  alias RecordVerifier.Accounts

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(beneficiary: %Accounts.Beneficiary{})
      |> assign(:page_title, "Beneficiaries")

    {:ok, socket}
  end

  @impl true
  def handle_event("show_item", %{"id" => beneficiary_id} = params, socket) do
    beneficiary = Accounts.get_beneficiary!(beneficiary_id)

    socket =
      socket
      |> assign(beneficiary: beneficiary)
      |> push_event("open-daisy-modal", %{id: "my_modal_1"})

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <dialog id="my_modal_1" class="modal">
        <div class="modal-box max-w-5xl">
          <div class="flex justify-between">
            <div>
              <h1 class="text-xl font-bold">
                {@beneficiary.first_name} {@beneficiary.middle_name} {@beneficiary.last_name}
              </h1>
              <p class="text-sm text-slate-500">
                Beneficiary name
              </p>
            </div>
            <div>
              <div class="modal-action !m-0">
                <.link class="btn" navigate={url_beneficiary(@beneficiary, "edit")}>Edit</.link>
                <form method="dialog">
                  <!-- if there is a button in form, it will close the modal -->
                  <.link class="btn">Close</.link>
                </form>
              </div>
              <p class="text-xs text-slate-500 mt-2">
                Press ESC key or click the button below to close
              </p>
            </div>
          </div>
          <ul :if={@beneficiary} class="grid gap-4 grid-cols-4 mt-4">
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.monthly_income}
              </span>
              <span class="text-sm text-slate-500">
                Monthly Income
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.birth_date}
              </span>
              <span class="text-sm text-slate-500">
                Birth Date (DD/MM/YYYY)
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.sex}
              </span>
              <span class="text-sm text-slate-500">
                Sex
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.civil_status}
              </span>
              <span class="text-sm text-slate-500">
                Civil Status
              </span>
            </li>
            <li class="col-span-2 flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.barangay} {@beneficiary.city_or_municipality} {@beneficiary.province} {@beneficiary.district} District
              </span>
              <span class="text-sm text-slate-500">
                Address
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.occupation}
              </span>
              <span class="text-sm text-slate-500">
                Occupation
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.age}
              </span>
              <span class="text-sm text-slate-500">
                Age
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.contact_number}
              </span>
              <span class="text-sm text-slate-500">
                Contact number
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.id_type}
              </span>
              <span class="text-sm text-slate-500">
                ID Type
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.id_number}
              </span>
              <span class="text-sm text-slate-500">
                ID Number
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.place_of_issue}
              </span>
              <span class="text-sm text-slate-500">
                Place of Issue
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.dependent}
              </span>
              <span class="text-sm text-slate-500">
                Dependent
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {@beneficiary.beneficiary_type}
              </span>
              <span class="text-sm text-slate-500">
                Beneficiary Type
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {if @beneficiary.interested, do: "Yes", else: "No"}
              </span>
              <span class="text-sm text-slate-500">
                Interested in wage employment or self-employment?
              </span>
            </li>
            <li class="flex flex-col border rounded p-2 justify-center text-center">
              <span>
                {if @beneficiary.skills_needed, do: "Yes", else: "No"}
              </span>
              <span class="text-sm text-slate-500">
                Skills Training Needed
              </span>
            </li>
          </ul>
        </div>
      </dialog>
      <div class="container mx-auto">
        <.button variant="primary" navigate={~p"/beneficiaries/new"}>
          <.icon name="hero-plus" /> New Beneficiary
        </.button>
      </div>
      <Cinder.collection
        actor={@current_user}
        resource={RecordVerifier.Accounts.Beneficiary}
        theme="daisy_ui"
        click={fn item -> JS.push("show_item", value: %{id: item.id}) end}
        page_size={[default: 25, options: [10, 25, 50, 100]]}
        selectable
        class="container mx-auto"
      >
        <:col :let={beneficiary} field="first_name" sort search>
          {beneficiary.first_name}
        </:col>
        <:col :let={beneficiary} field="middle_name" sort search>
          {beneficiary.middle_name}
        </:col>
        <:col :let={beneficiary} field="last_name" sort search>
          {beneficiary.last_name}
        </:col>
        <:col :let={beneficiary} field="barangay" sort search>
          {beneficiary.barangay}
        </:col>
        <:col :let={beneficiary} field="city_or_municipality" sort search>
          {beneficiary.city_or_municipality}
        </:col>
        <:col :let={beneficiary} field="province" sort search>
          {beneficiary.province}
        </:col>
        <:col :let={beneficiary} field="district" sort search>
          {beneficiary.district}
        </:col>
        <:col :let={beneficiary} field="id_type" sort search>
          {beneficiary.id_type}
        </:col>
        <:col :let={beneficiary} field="id_number" sort search>
          {beneficiary.id_number}
        </:col>
        <:col :let={beneficiary} field="place_of_issue" sort search>
          {beneficiary.place_of_issue}
        </:col>
        <:col :let={beneficiary} field="contact_number" sort>
          {beneficiary.contact_number}
        </:col>
        <:col :let={beneficiary} field="beneficiary_type" sort>
          {beneficiary.beneficiary_type}
        </:col>
        <:col :let={beneficiary} field="occupation" sort search>
          {beneficiary.occupation}
        </:col>
        <:col :let={beneficiary} field="sex" sort>
          {beneficiary.sex}
        </:col>
        <:col :let={beneficiary} field="civil_status" sort>
          {beneficiary.civil_status}
        </:col>
        <:col :let={beneficiary} field="age" sort>
          {beneficiary.age}
        </:col>
        <:col :let={beneficiary} field="monthly_income" sort>
          {beneficiary.monthly_income}
        </:col>
        <:col :let={beneficiary} field="dependent" sort search>
          {beneficiary.dependent}
        </:col>
        <:col
          :let={beneficiary}
          field="interested"
          label="Interested in wage employment or self-employment?"
          filter
          sort
          boolean
        >
          {if @beneficiary.interested, do: "Yes", else: "No"}
        </:col>
        <:col
          :let={beneficiary}
          field="skills_needed"
          label="Skills Training Needed"
          filter
          sort
          boolean
        >
          {if @beneficiary.skills_needed, do: "Yes", else: "No"}
        </:col>
        <:col :let={beneficiary} field="birth_date" label="Birth date (DD/MM/YYYY)" filter sort>
          {beneficiary.birth_date}
        </:col>
      </Cinder.collection>
    </Layouts.app>
    """
  end

  defp url_beneficiary(state, type) do
    case state do
      nil ->
        ~p"/beneficiaries"

      %Accounts.Beneficiary{id: nil} ->
        ~p"/beneficiaries"

      beneficiary ->
        ~p"/beneficiaries/#{beneficiary.id}/#{type}"
    end
  end
end
