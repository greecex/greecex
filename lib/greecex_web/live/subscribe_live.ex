defmodule GreecexWeb.SubscribeLive do
  use GreecexWeb, :live_view

  alias Greecex.Subscribers
  alias Greecex.Subscribers.Subscriber

  alias RemoteIp

  require Logger

  def mount(_params, _session, socket) do
    changeset = Subscribers.change_subscriber(%Subscriber{})
    peer_data = get_connect_info(socket, :peer_data)
    x_headers = get_connect_info(socket, :x_headers)

    address =
      RemoteIp.from(x_headers, proxies: ["66.241.124.124"])

    address_as_string =
      cond do
        address != nil ->
          address
          |> Tuple.to_list()
          |> Enum.join(".")

        true ->
          peer_data.address |> Tuple.to_list() |> Enum.join(".")
      end

    {:ok,
     assign(socket,
       page_title: "Subscribe",
       changeset: changeset,
       success: false,
       show: true,
       error: nil,
       client_ip: address_as_string,
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
        <!-- Static honeypot field -->
        <.input name="website" value="" type="text" style="display: none;" />
        <div class="prose">
          <p>
            By submitting this form, you confirm that you have read and agreed to our <.link navigate="/policies">policies</.link>.
          </p>
        </div>
        <:actions>
          <.button phx-disable-with="Subscribing..." type="submit">Subscribe</.button>
        </:actions>
      </.simple_form>
      <%= if @error do %>
        <p class="mt-2 text-red-600 text-sm text-center">{@error}</p>
      <% end %>
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

  def handle_event(
        "subscribe",
        %{"subscriber" => subscriber_params, "website" => website},
        socket
      ) do
    if website != "" do
      Logger.warning("Possible bot detected from #{socket.assigns.client_ip}", subscriber_params)

      {:noreply,
       assign(socket,
         error: "It seems like you're a bot. If not, please try again.",
         success: false,
         show: true
       )}
    else
      key = "subscription:#{socket.assigns.client_ip}"

      case Greecex.RateLimit.hit(key, :timer.hours(1), 8) do
        {:allow, _count} ->
          case Subscribers.create_subscriber(subscriber_params) do
            {:ok, _subscriber} ->
              Logger.info(
                "Subscriber with email #{subscriber_params["email"]} created from #{socket.assigns.client_ip}"
              )

              {:noreply, assign(socket, success: true, show: false, error: nil)}

            {:error, %Ecto.Changeset{errors: [email: {"has already been taken", _}]}} ->
              {:noreply, assign(socket, success: true, show: false, error: nil)}

            {:error, changeset} ->
              {:noreply,
               assign(socket,
                 form: to_form(changeset),
                 error: "Something went wrong. Please try again.",
                 success: false,
                 show: true
               )}
          end

        {:deny, _retry_after} ->
          Logger.error("Too many requests from #{socket.assigns.client_ip}")

          {:noreply,
           assign(socket,
             error: "Too many requests. Try again in a bit.",
             success: false,
             show: true
           )}
      end
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
