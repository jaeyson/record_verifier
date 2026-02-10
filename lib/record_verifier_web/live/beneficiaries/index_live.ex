defmodule RecordVerifierWeb.Beneficiaries.IndexLive do
  use RecordVerifierWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Beneficiaries")

    {:ok, socket}
  end

  @impl true
  def handle_event("show_item", %{"id" => beneficiary_id}, socket) do
    dbg(socket)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="modal" class="modal">
      My Modal
    </div>

    <button phx-click={JS.add_class("show", to: "#modal", transition: "fade-in")}>
      show modal
    </button>

    <button phx-click={JS.remove_class("show", to: "#modal", transition: "fade-out")}>
      hide modal
    </button>
    <Cinder.collection
      actor={@current_user}
      resource={RecordVerifier.Accounts.Beneficiary}
      theme="daisy_ui"
      page_size={10}
      click={fn item -> JS.push("show_item", value: %{id: item.id}) end}
      selectable
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
        {beneficiary.interested}
      </:col>
      <:col
        :let={beneficiary}
        field="skills_needed"
        label="Skills Training Needed"
        filter
        sort
        boolean
      >
        {beneficiary.skills_needed}
      </:col>
      <:col :let={beneficiary} field="birth_date" label="Birth date (DD/MM/YYYY)" filter sort>
        {beneficiary.birth_date}
      </:col>
    </Cinder.collection>
    """
  end
end
