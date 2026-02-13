defmodule RecordVerifierWeb.BeneficiaryLive.Index do
  use RecordVerifierWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Beneficiaries
        <:actions>
          <.button variant="primary" navigate={~p"/beneficiaries/new"}>
            <.icon name="hero-plus" /> New Beneficiary
          </.button>
        </:actions>
      </.header>

      <.table
        id="beneficiaries"
        rows={@streams.beneficiaries}
        row_click={fn {_id, beneficiary} -> JS.navigate(~p"/beneficiaries/#{beneficiary}") end}
      >
        <:col :let={{_id, beneficiary}} label="Id">{beneficiary.id}</:col>

        <:action :let={{_id, beneficiary}}>
          <div class="sr-only">
            <.link navigate={~p"/beneficiaries/#{beneficiary}"}>Show</.link>
          </div>

          <.link navigate={~p"/beneficiaries/#{beneficiary}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, beneficiary}}>
          <.link
            phx-click={JS.push("delete", value: %{id: beneficiary.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Beneficiaries")
     |> assign_new(:current_user, fn -> nil end)
     |> stream(
       :beneficiaries,
       Ash.read!(RecordVerifier.Accounts.Beneficiary, actor: socket.assigns[:current_user])
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    beneficiary =
      Ash.get!(RecordVerifier.Accounts.Beneficiary, id, actor: socket.assigns.current_user)

    Ash.destroy!(beneficiary, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :beneficiaries, beneficiary)}
  end
end
