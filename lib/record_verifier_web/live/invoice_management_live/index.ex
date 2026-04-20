defmodule RecordVerifierWeb.InvoiceManagementLive.Index do
  use RecordVerifierWeb, :live_view
  alias Fluxon.Components.Table
  alias Fluxon.Components.Button
  alias Fluxon.Components.Input
  alias RecordVerifierWeb.Beneficiaries
  alias RecordVerifier.Accounts

  def mount(_params, _session, socket) do
    visible_columns =
      Accounts.Beneficiary
      |> Ash.Resource.Info.attributes()
      |> Enum.reject(
        &(&1.name in [
            :id,
            :inserted_at,
            :updated_at,
            :first_name,
            :middle_name,
            :last_name,
            :birth_date,
            :age,
            :committer,
            :spread_sheet_id
          ])
      )
      |> Enum.map(&to_string(&1.name))

    # Fetch all attribute names and transform them into a map of "name" => true
    columns_form =
      Accounts.Beneficiary
      |> Ash.Resource.Info.attributes()
      |> Enum.reject(&(&1.name in [:id, :inserted_at, :updated_at]))
      |> Map.new(fn attr -> {Atom.to_string(attr.name), true} end)

    {:ok,
     assign(socket,
       page_title: "Beneficiaries",
       beneficiary: %Accounts.Beneficiary{},
       visible_columns: visible_columns,
       columns_form: to_form(columns_form)
     )}
  end

  @impl true
  def handle_event("show_item", %{"id" => beneficiary_id} = params, socket) do
    beneficiary = Accounts.get_beneficiary!(beneficiary_id)

    socket =
      socket
      |> assign(beneficiary: beneficiary)
      |> push_event("open-daisy-modal", %{id: "modal-beneficiaries"})

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.sheet id="mobile-sidebar-nav" placement="left" class="w-full max-w-xs">
      <div class="flex mb-6 shrink-0 items-center">
        <img src="https://fluxonui.com/images/logos/1.svg" alt="Fluxon" class="h-7 w-auto" />
      </div>

      <.navlist heading="Main">
        <.navlink navigate="/dashboard">
          <.icon
            name="hero-squares-2x2"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          /> Overview
        </.navlink>
        <.navlink navigate="/invoices">
          <.icon
            name="hero-document-text"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          />
          <span class="flex-1">Invoices</span>
          <.icon name="hero-star-solid" class="size-4 text-orange-400 ml-auto" />
        </.navlink>
        <.navlink navigate="/customers">
          <.icon name="hero-users" class="size-5 text-foreground-softer group-hover:text-foreground" />
          <span class="flex-1">Customers</span>
          <.icon name="hero-star-solid" class="size-4 text-orange-400 ml-auto" />
        </.navlink>
        <.navlink navigate="/payments">
          <.icon
            name="hero-credit-card"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          /> Acknowledgement
        </.navlink>
        <.navlink navigate="/reports">
          <.icon
            name="hero-chart-bar"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          />
          <span class="flex-1">Reports</span>
          <.badge color="info" class="ml-auto">New</.badge>
        </.navlink>
        <.navlink navigate="/tasks">
          <.icon
            name="hero-adjustments-horizontal"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          />
          <span class="flex-1">Tasks</span>
          <.tooltip value="Add to favorites">
            <.icon name="hero-star" class="size-4 ml-auto text-foreground-softer" />
          </.tooltip>
        </.navlink>
        <.navlink navigate="/archive">
          <.icon
            name="hero-archive-box"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          />
          <span class="flex-1">Archive</span>
          <.tooltip value="Add to favorites">
            <.icon name="hero-star" class="size-4 ml-auto text-foreground-softer" />
          </.tooltip>
        </.navlink>
      </.navlist>

      <.navlist heading="Projects">
        <.navlink phx-click={JS.toggle_attribute({"data-expanded", ""})} class="group" data-expanded>
          <span class="flex size-2 rounded-full bg-red-500 group-data-[active]:bg-red-600"></span>
          <span class="flex-1">Work Program</span>
          <.icon
            name="hero-chevron-right"
            class="size-4 ml-auto text-foreground-softer group-data-[active]:text-inherit in-data-expanded:rotate-90 transition-transform duration-200"
          />
        </.navlink>
        <div class="grid grid-rows-[0fr] [[data-expanded]~&]:grid-rows-[1fr] transition-all duration-200">
          <div class="overflow-hidden ml-4">
            <.navlink navigate="/projects/fluxon/api" class="group">
              <span class="flex size-2 rounded-full bg-zinc-400 group-data-[active]:bg-zinc-500">
              </span>
              API Integration
            </.navlink>
            <.navlink navigate="/projects/fluxon/ui" class="group">
              <span class="flex size-2 rounded-full bg-zinc-400 group-data-[active]:bg-zinc-500">
              </span>
              UI Refresh
            </.navlink>
          </div>
        </div>
        <.navlink navigate="/projects/website" class="group">
          <span class="flex size-2 rounded-full bg-blue-500 group-data-[active]:bg-blue-600"></span>
          Attendance
        </.navlink>
      </.navlist>

      <.navlist class="mt-auto!">
        <.navlink navigate="/settings">
          <.icon
            name="hero-cog-6-tooth"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          /> Settings
        </.navlink>
        <.navlink navigate="/help">
          <.icon
            name="hero-question-mark-circle"
            class="size-5 text-foreground-softer group-hover:text-foreground"
          /> Help & Support
        </.navlink>
      </.navlist>
    </.sheet>

    <dialog id="modal-beneficiaries" class="modal">
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
              <.link
                class="btn"
                phx-click={JS.dispatch("close-daisy-modal", to: "#modal-beneficiaries")}
              >
                Close
              </.link>
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
    <div class="relative isolate flex min-h-svh w-full bg-base max-lg:flex-col">
      <div class="z-50 fixed inset-y-0 left-0 w-72 max-lg:hidden border-r border-base">
        <div class="flex h-full flex-col">
          <div class="flex flex-1 flex-col overflow-y-auto p-6">
            <div class="flex items-center justify-between mb-4">
              <div class="flex shrink-0 items-center gap-2">
                <img src="/images/dole.png" alt="Fluxon" class="h-12 w-auto" />
                <span class="text-xl font-bold text-foreground">SARFO DDB</span>
              </div>
              <.dropdown class="w-56">
                <:toggle class="w-full">
                  <button class="cursor-pointer rounded-full size-6 overflow-hidden">
                    <img src="https://i.pravatar.cc/150?u=Mike+Doe" alt="John Doe" class="inline" />
                  </button>
                </:toggle>

                <.dropdown_link navigate="/profile">
                  <.icon name="hero-user-circle" class="icon" /> Your profile
                </.dropdown_link>
                <.dropdown_link navigate="/appearance">
                  <.icon name="hero-sun" class="icon" /> Appearance
                </.dropdown_link>
                <.dropdown_link navigate="/settings">
                  <.icon name="hero-cog-6-tooth" class="icon text-foreground-softer" /> Settings
                </.dropdown_link>
                <.dropdown_link navigate="/notifications">
                  <.icon name="hero-bell" class="icon text-foreground-softer" /> Notifications
                </.dropdown_link>

                <.dropdown_separator />

                <.dropdown_link navigate="/upgrade">
                  <.icon name="hero-star-solid" class="icon text-orange-600!" /> Upgrade
                  <.badge color="warning" class="ml-auto font-medium">20% off</.badge>
                </.dropdown_link>

                <.dropdown_link navigate="/referrals">
                  <.icon name="hero-gift" class="icon text-foreground-softer" /> Referrals
                </.dropdown_link>

                <.dropdown_link navigate="/download">
                  <.icon name="hero-arrow-down-circle" class="icon text-foreground-softer" />
                  Download app
                </.dropdown_link>

                <.dropdown_link navigate="/whats-new">
                  <.icon name="hero-sparkles" class="icon text-foreground-softer" /> What's new?
                </.dropdown_link>

                <.dropdown_link navigate="/help">
                  <.icon name="hero-question-mark-circle" class="icon text-foreground-softer" />
                  Get help?
                </.dropdown_link>

                <.dropdown_separator />

                <.dropdown_link
                  navigate="/signout"
                  class="text-red-600 data-highlighted:text-red-700 data-highlighted:bg-red-50"
                >
                  <.icon name="hero-arrow-right-on-rectangle" class="icon text-red-500" /> Sign out
                </.dropdown_link>
              </.dropdown>
            </div>

            <p class="border border-slate-300 rounded p-2 flex justify-between items-center gap-2 mb-8">
              Juan Dela Cruz
              <.badge color="success">
                <.icon name="hero-check-circle" class="icon" /> Admin
              </.badge>
            </p>
            <.navlist heading="Main">
              <.navlink navigate="/dashboard">
                <.icon name="hero-squares-2x2" class="size-5" /> Overview
              </.navlink>
              <.navlink navigate="/invoices" active>
                <.icon name="hero-document-text" class="size-5" />
                <span class="flex-1">Beneficiaries</span>
                <.icon name="hero-star-solid" class="size-4 text-orange-400 ml-auto" />
              </.navlink>
              <.navlink navigate="/dev/dashboard/home">
                <.icon name="hero-users" class="size-5" />
                <span class="flex-1">Server Dashboard</span>
                <.icon name="hero-star-solid" class="size-4 text-orange-400 ml-auto" />
              </.navlink>
              <.navlink navigate="/payments">
                <.icon name="hero-credit-card" class="size-5" /> Acknowledgement
              </.navlink>
              <.navlink navigate="/reports">
                <.icon name="hero-chart-bar" class="size-5" />
                <span class="flex-1">Reports</span>
                <.badge color="info" class="ml-auto">New</.badge>
              </.navlink>
              <.navlink navigate="/tasks">
                <.icon name="hero-adjustments-horizontal" class="size-5" />
                <span class="flex-1">Tasks</span>
                <.tooltip value="Add to favorites">
                  <.icon name="hero-star" class="size-4 ml-auto text-foreground-softer" />
                </.tooltip>
              </.navlink>
              <.navlink navigate="/archive">
                <.icon name="hero-archive-box" class="size-5" />
                <span class="flex-1">Archive</span>
                <.tooltip value="Add to favorites">
                  <.icon name="hero-star" class="size-4 ml-auto text-foreground-softer" />
                </.tooltip>
              </.navlink>
            </.navlist>

            <.navlist heading="Projects">
              <.navlink
                phx-click={JS.toggle_attribute({"data-expanded", ""})}
                class="group"
                data-expanded
              >
                <span class="flex size-2 rounded-full bg-red-500 group-data-[active]:bg-red-600">
                </span>
                <span class="flex-1">Work Program</span>
                <.icon
                  name="hero-chevron-right"
                  class="size-4 ml-auto text-foreground-softer group-data-[active]:text-inherit in-data-expanded:rotate-90 transition-transform duration-200"
                />
              </.navlink>
              <div class="grid grid-rows-[0fr] [[data-expanded]~&]:grid-rows-[1fr] transition-all duration-200">
                <div class="overflow-hidden ml-2 px-2">
                  <.navlink navigate="/projects/fluxon/api" class="group">
                    <span class="flex size-2 rounded-full bg-zinc-400 group-data-[active]:bg-zinc-500">
                    </span>
                    Implementation
                  </.navlink>
                  <.navlink navigate="/projects/fluxon/ui" class="group">
                    <span class="flex size-2 rounded-full bg-zinc-400 group-data-[active]:bg-zinc-500">
                    </span>
                    Financial Requirements
                  </.navlink>
                </div>
              </div>
              <.navlink navigate="/projects/website" class="group">
                <span class="flex size-2 rounded-full bg-blue-500 group-data-[active]:bg-blue-600">
                </span>
                Attendance
              </.navlink>
            </.navlist>

            <.navlist class="mt-auto!">
              <.navlink navigate="/settings">
                <.icon
                  name="hero-cog-6-tooth"
                  class="size-5 text-foreground-softer group-hover:text-foreground"
                /> Settings
              </.navlink>
              <.navlink navigate="/help">
                <.icon
                  name="hero-question-mark-circle"
                  class="size-5 text-foreground-softer group-hover:text-foreground"
                /> Help & Support
              </.navlink>
            </.navlist>
          </div>
        </div>
      </div>

      <main class="flex flex-1 flex-col lg:min-w-0 lg:pl-72">
        <header class="bg-base sticky z-10 top-0 flex h-14 shrink-0 items-center gap-x-3 border-b border-base px-4 sm:px-6">
          <button
            phx-click={Fluxon.open_dialog("mobile-sidebar-nav")}
            class="relative cursor-pointer flex min-w-0 items-center -m-2 p-2 lg:hidden"
          >
            <.icon name="hero-bars-3" class="size-6" />
          </button>

          <.separator vertical class="my-5 lg:hidden" />

          <h1 class="text-lg font-semibold text-foreground flex items-center gap-x-2">
            <div class="size-6 flex items-center justify-center rounded-md text-white bg-radial from-blue-500 to-blue-600 shadow">
              <.icon name="hero-document-text" class="size-4" />
            </div>
            Beneficiaries
          </h1>

          <span class="text-foreground hidden sm:block">/</span>

          <span class="text-foreground font-medium text-sm hidden sm:block">
            {RecordVerifier.Accounts.total_beneficiaries()} Beneficiaries
          </span>

          <div class="ml-auto flex items-center gap-x-4 lg:gap-x-6">
            <.popover
              id="columns-popover"
              placement="bottom-start"
              class=" [&:has(.phx-change-loading)_[data-loading]]:flex"
            >
              <Button.button variant="dashed">
                <.icon name="hero-view-columns" class="icon" />
                <span class="hidden lg:inline ml-1">Columns</span>
              </Button.button>
              <:content>
                <div
                  class="absolute inset-px bg-base/70 items-center justify-center hidden"
                  data-loading
                >
                  <.loading class="text-foreground-softer" />
                </div>
                <h3 class="font-medium">Columns</h3>
                <.form :let={f} for={@columns_form} phx-change="update_columns">
                  <div class="flex items-center justify-between mt-3">
                    <.label for="barangay" class="text-foreground">Barangay</.label>
                    <.switch
                      id="barangay"
                      field={f[:barangay]}
                      value={@visible_columns |> Enum.member?("barangay")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="city_or_municipality" class="text-foreground">
                      City or Municipality
                    </.label>
                    <.switch
                      id="city_or_municipality"
                      field={f[:city_or_municipality]}
                      value={@visible_columns |> Enum.member?("city_or_municipality")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="province" class="text-foreground">Province</.label>
                    <.switch
                      id="province"
                      field={f[:province]}
                      value={@visible_columns |> Enum.member?("province")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="district" class="text-foreground">District</.label>
                    <.switch
                      id="district"
                      field={f[:district]}
                      value={@visible_columns |> Enum.member?("district")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="id_type" class="text-foreground">ID Type</.label>
                    <.switch
                      id="id_type"
                      field={f[:id_type]}
                      value={@visible_columns |> Enum.member?("id_type")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="id_number" class="text-foreground">ID Number</.label>
                    <.switch
                      id="id_number"
                      field={f[:id_number]}
                      value={@visible_columns |> Enum.member?("id_number")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="place_of_issue" class="text-foreground">Place of Issue</.label>
                    <.switch
                      id="place_of_issue"
                      field={f[:place_of_issue]}
                      value={@visible_columns |> Enum.member?("place_of_issue")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="contact_number" class="text-foreground">Contact Number</.label>
                    <.switch
                      id="contact_number"
                      field={f[:contact_number]}
                      value={@visible_columns |> Enum.member?("contact_number")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="beneficiary_type" class="text-foreground">Beneficiary Type</.label>
                    <.switch
                      id="beneficiary_type"
                      field={f[:beneficiary_type]}
                      value={@visible_columns |> Enum.member?("beneficiary_type")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="occupation" class="text-foreground">Occupation</.label>
                    <.switch
                      id="occupation"
                      field={f[:occupation]}
                      value={@visible_columns |> Enum.member?("occupation")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="sex" class="text-foreground">Sex</.label>
                    <.switch
                      id="sex"
                      field={f[:sex]}
                      value={@visible_columns |> Enum.member?("sex")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="civil_status" class="text-foreground">Civil Status</.label>
                    <.switch
                      id="civil_status"
                      field={f[:civil_status]}
                      value={@visible_columns |> Enum.member?("civil_status")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="monthly_income" class="text-foreground">Monthly Income</.label>
                    <.switch
                      id="monthly_income"
                      field={f[:monthly_income]}
                      value={@visible_columns |> Enum.member?("monthly_income")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="dependent" class="text-foreground">Dependent</.label>
                    <.switch
                      id="dependent"
                      field={f[:dependent]}
                      value={@visible_columns |> Enum.member?("dependent")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="interested" class="text-foreground mr-4">
                      Interested in employment?
                    </.label>
                    <.switch
                      id="interested"
                      field={f[:interested]}
                      value={@visible_columns |> Enum.member?("interested")}
                    />
                  </div>
                  <div class="flex items-center justify-between mt-3">
                    <.label for="skills_needed" class="text-foreground">Skills needed?</.label>
                    <.switch
                      id="skills_needed"
                      field={f[:skills_needed]}
                      value={@visible_columns |> Enum.member?("skills_needed")}
                    />
                  </div>
                </.form>
              </:content>
            </.popover>

            <div class="ml-auto">
              <Button.button variant="dashed">
                <.icon name="hero-cog-6-tooth" class="icon" /> Settings
              </Button.button>
            </div>
            <Button.button
              variant="primary"
              navigate={url_beneficiary(@beneficiary, "create")}
              class="-mx-2 px-2"
            >
              <.icon name="hero-plus" class="size-4" /> Create beneficiary
            </Button.button>
          </div>
        </header>

        <div class="grow lg:rounded-base">
          <div class="overflow-x-auto">
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
              <:col
                :let={beneficiary}
                :if={"barangay" in @visible_columns}
                field="barangay"
                sort
                search
              >
                {beneficiary.barangay}
              </:col>
              <:col
                :let={beneficiary}
                :if={"city_or_municipality" in @visible_columns}
                field="city_or_municipality"
                sort
                search
              >
                {beneficiary.city_or_municipality}
              </:col>
              <:col
                :let={beneficiary}
                :if={"province" in @visible_columns}
                field="province"
                sort
                search
              >
                {beneficiary.province}
              </:col>
              <:col
                :let={beneficiary}
                :if={"district" in @visible_columns}
                field="district"
                sort
                search
              >
                {beneficiary.district}
              </:col>
              <:col
                :let={beneficiary}
                :if={"id_type" in @visible_columns}
                field="id_type"
                sort
                search
              >
                {beneficiary.id_type}
              </:col>
              <:col
                :let={beneficiary}
                :if={"id_number" in @visible_columns}
                field="id_number"
                sort
                search
              >
                {beneficiary.id_number}
              </:col>
              <:col
                :let={beneficiary}
                :if={"place_of_issue" in @visible_columns}
                field="place_of_issue"
                sort
                search
              >
                {beneficiary.place_of_issue}
              </:col>
              <:col
                :let={beneficiary}
                :if={"contact_number" in @visible_columns}
                field="contact_number"
                sort
              >
                {beneficiary.contact_number}
              </:col>
              <:col
                :let={beneficiary}
                :if={"beneficiary_type" in @visible_columns}
                field="beneficiary_type"
                sort
              >
                {beneficiary.beneficiary_type}
              </:col>
              <:col
                :let={beneficiary}
                :if={"occupation" in @visible_columns}
                field="occupation"
                sort
                search
              >
                {beneficiary.occupation}
              </:col>
              <:col :let={beneficiary} :if={"sex" in @visible_columns} field="sex" sort>
                {beneficiary.sex}
              </:col>
              <:col
                :let={beneficiary}
                :if={"civil_status" in @visible_columns}
                field="civil_status"
                sort
              >
                {beneficiary.civil_status}
              </:col>
              <:col :let={beneficiary} field="age" sort>
                {beneficiary.age}
              </:col>
              <:col
                :let={beneficiary}
                :if={"monthly_income" in @visible_columns}
                field="monthly_income"
                sort
              >
                {beneficiary.monthly_income}
              </:col>
              <:col
                :let={beneficiary}
                :if={"dependent" in @visible_columns}
                field="dependent"
                sort
                search
              >
                {beneficiary.dependent}
              </:col>
              <:col
                :let={beneficiary}
                :if={"interested" in @visible_columns}
                field="interested"
                label="Intereseted in employment?"
                filter
                sort
                boolean
              >
                {if @beneficiary.interested, do: "Yes", else: "No"}
              </:col>
              <:col
                :let={beneficiary}
                :if={"skills_needed" in @visible_columns}
                field="skills_needed"
                label="Training needed?"
                filter
                sort
                boolean
              >
                {if @beneficiary.skills_needed, do: "Yes", else: "No"}
              </:col>
              <:col
                :let={beneficiary}
                field="birth_date"
                label="Birth date (DD/MM/YYYY)"
                filter
                sort
              >
                {beneficiary.birth_date}
              </:col>
            </Cinder.collection>
          </div>
        </div>
      </main>
    </div>
    """
  end

  defp url_beneficiary(state, type) do
    case state do
      nil ->
        ~p"/beneficiaries"

      %Accounts.Beneficiary{id: nil} ->
        ~p"/beneficiaries/new"

      beneficiary ->
        ~p"/beneficiaries/#{beneficiary.id}/#{type}"
    end
  end

  def handle_event("update_columns", columns, socket) do
    visible_columns =
      columns
      |> Map.keys()
      |> Enum.filter(&Phoenix.HTML.Form.normalize_value("checkbox", columns[&1]))

    {:noreply, assign(socket, columns_form: to_form(columns), visible_columns: visible_columns)}
  end
end
