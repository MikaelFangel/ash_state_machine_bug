defmodule HelpdeskWeb.StateLive.Edit do
  @moduledoc false
  use HelpdeskWeb, :live_view

  alias AshPhoenix.Form
  alias Helpdesk.Support.Ticket

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    ticket = Ticket |> Ash.get!(id)

    form =
      ticket
      |> Form.for_update(:update, forms: [auto?: true])
      |> to_form()

    {:ok, socket |> assign(:form, form)}
  end
end
