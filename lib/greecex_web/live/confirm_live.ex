defmodule GreecexWeb.ConfirmLive do
  use GreecexWeb, :live_view
  alias Greecex.Subscribers

  def mount(%{"token" => token}, _session, socket) do
    case Subscribers.confirm_subscriber(token) do
      {:ok, _subscriber} ->
        {:ok, assign(socket, page_title: "Confirm subscription", status: :confirmed)}

      {:error, _reason} ->
        {:ok, assign(socket, page_title: "Confirm subscription", status: :invalid)}
    end
  end

  def render(assigns) do
    ~H"""
    <%= case @status do %>
      <% :confirmed -> %>
        <p>Thank you for confirming your subscription!</p>
      <% :invalid -> %>
        <p>Sorry, that confirmation link is invalid or has expired.</p>
    <% end %>
    """
  end
end
