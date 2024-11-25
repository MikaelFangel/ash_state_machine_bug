defmodule HelpdeskWeb.StateLive.New do
  @moduledoc false
  use HelpdeskWeb, :live_view

  alias AshPhoenix.Form
  alias Helpdesk.Support.Ticket

  @impl true
  def mount(_params, _session, socket) do
    form =
      Ticket
      |> Form.for_create(:create, forms: [auto?: true])
      |> to_form()

    {:ok, socket |> assign(:form, form)}
  end
end
