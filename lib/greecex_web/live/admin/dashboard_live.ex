defmodule GreecexWeb.Admin.DashboardLive do
  use GreecexWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if admin?(socket.assigns.current_user) do
      {:ok, socket}
    else
      {:ok, redirect(socket, to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>Admin Dashboard</h1>
      <p>Welcome to the admin dashboard!</p>
    </div>
    """
  end

  defp admin?(%Greecex.Accounts.User{role: "admin"}), do: true
  defp admin?(_), do: false
end
