defmodule RecordVerifierWeb.BeneficiaryLive.Show do
  use RecordVerifierWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Beneficiary {@beneficiary.id}
        <:subtitle>This is a beneficiary record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/beneficiaries"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/beneficiaries/#{@beneficiary}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Beneficiary
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@beneficiary.id}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Beneficiary")
     |> assign(
       :beneficiary,
       Ash.get!(RecordVerifier.Accounts.Beneficiary, id, actor: socket.assigns.current_user)
     )}
  end
end
