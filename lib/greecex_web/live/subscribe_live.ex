defmodule GreecexWeb.SubscribeLive do
  use GreecexWeb, :live_view

  alias Greecex.Subscribers
  alias Greecex.Subscribers.Subscriber

  def mount(_params, _session, socket) do
    changeset = Subscribers.change_subscriber(%Subscriber{})

    {:ok,
     assign(socket,
       page_title: "Subscribe",
       changeset: changeset,
       success: false,
       show: true,
       form: to_form(changeset),
       cities: city_options()
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto text-center px-6">
      <h1 class="text-3xl font-extrabold text-gray-900 tracking-tight">
        Subscribe for updates
      </h1>
    </div>

    <%= if @show do %>
      <.simple_form for={@form} id="subscribe-form" phx-change="validate" phx-submit="subscribe">
        <.input
          field={@form[:email]}
          label="Email"
          placeholder="Email address for upcoming events and conferences, and notifications"
          phx-debounce="2000"
        />
        <.input
          field={@form[:city]}
          label="City"
          type="select"
          options={@cities}
          prompt="Select the city nearest to you for in person meetups"
        />
        <.input
          field={@form[:willing_to_coorganize]}
          label="Are you interested in co-organizing meetups in the nearest city?"
          type="checkbox"
        />
        <.input
          field={@form[:elixir_experience]}
          label="What's your experience with Elixir? (Even if none, share a few words about you)"
          type="textarea"
        />
        <div class="prose">
          <p>
            By submitting this form you accept our <.link navigate="/policies">policies</.link>.
          </p>
        </div>
        <:actions>
          <.button phx-disable-with="Subscribing..." type="submit">Subscribe</.button>
        </:actions>
      </.simple_form>
    <% end %>

    <%= if @success do %>
      <p class="mt-4 text-green-600 text-sm text-center">
        Thank you for subscribing! Please check your email for confirmation.
      </p>
    <% end %>
    """
  end

  def handle_event("validate", %{"subscriber" => subscriber_params}, socket) do
    changeset =
      %Subscriber{}
      |> Subscribers.change_subscriber(subscriber_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("subscribe", %{"subscriber" => subscriber_params}, socket) do
    case Subscribers.create_subscriber(subscriber_params) do
      {:ok, _subscriber} ->
        {:noreply, assign(socket, success: true, show: false)}

      {:error, %Ecto.Changeset{errors: [email: {"has already been taken", _}]}} ->
        {:noreply, assign(socket, success: true, show: false)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp city_options do
    [
      "Agrinio",
      "Alexandroupoli",
      "Athens",
      "Chalcis",
      "Chania",
      "Heraklion",
      "Ioannina",
      "Kalamata",
      "Katerini",
      "Kavala",
      "Komotini",
      "Lamia",
      "Larissa",
      "Patras",
      "Serres",
      "Thessaloniki",
      "Trikala",
      "Volos",
      "Xanthi"
    ]
  end
end
