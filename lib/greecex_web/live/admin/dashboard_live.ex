defmodule GreecexWeb.Admin.DashboardLive do
  use GreecexWeb, :live_view

  alias Greecex.Subscribers

  @impl true
  def mount(_params, _session, socket) do
    if admin?(socket.assigns.current_user) do
      subscribers = Subscribers.list_subscribers()
      count = Enum.count(subscribers)
      {:ok, assign(socket, subscribers: subscribers, count: count)}
    else
      {:ok, redirect(socket, to: "/404")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="prose">
      <h1>Admin dashboard</h1>
      <p>Welcome to the admin dashboard!</p>

      <h2>Subscribers ({@count})</h2>
      <ul>
        <%= for subscriber <- @subscribers do %>
          <li class="text-sm">
            <.link href={
                    "mailto:#{subscriber.email}?subject=" <>
                    URI.encode("Welcome to Greece |> Elixir") <>
                    "&body=" <>
                    URI.encode("Hello #{subscriber.email},\n\nPlease confirm your email address to never miss an update:\n\n#{Subscribers.get_subscription_confirmation_url(subscriber)}\n\nCheers,\nPetros @ Greece |> Elixir")
                  }>
              {subscriber.email}
            </.link>
          </li>
          <ul class="text-xs">
            <li>Subscribed on: {subscriber.inserted_at}</li>
            <li>Confirmation link: {Subscribers.get_subscription_confirmation_url(subscriber)}</li>
            <li>{if subscriber.confirmed_at, do: "Confirmed", else: "Pending confirmation"}</li>
            <li>City: {subscriber.city}</li>
            <li>Elixir experience: {subscriber.elixir_experience}</li>
            <li>
              Willing to co-organize: {if subscriber.willing_to_coorganize, do: "Yes", else: "No"}
            </li>
          </ul>
        <% end %>
      </ul>
    </div>
    """
  end

  defp admin?(%Greecex.Accounts.User{role: "admin"}), do: true
  defp admin?(_), do: false
end
