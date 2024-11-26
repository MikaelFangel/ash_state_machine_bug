defmodule HelpdeskWeb.StateLive.FormComponent do
  @moduledoc false
  use HelpdeskWeb, :live_component

  alias AshPhoenix.Form

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(:action, assigns[:action])
      |> assign(:form, assigns[:form])

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"form" => params}, socket) do
    form = Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"form" => params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
      {:ok, ticket} ->
        {:noreply,
         socket
         |> push_navigate(to: ~p"/#{ticket.id}/edit")}

      {:error, form} ->
        {:noreply, assign(socket, :form, form)}
    end
  end
end
