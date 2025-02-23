defmodule GreecexWeb.ConfirmLive do
  use GreecexWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <p>Thank you for confirming</p>
    """
  end
end
