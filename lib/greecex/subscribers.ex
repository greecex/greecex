defmodule Greecex.Subscribers do
  import Ecto.Query, warn: false
  alias Greecex.Repo
  alias Greecex.Subscribers.Subscriber
  alias Greecex.Subscribers.SubscriberNotifier

  use Phoenix.VerifiedRoutes, endpoint: GreecexWeb.Endpoint, router: GreecexWeb.Router

  @doc """
  Creates a new subscriber with the given attributes.

  Returns `{:ok, subscriber}` on success or `{:error, changeset}` on failure.

  ## Examples

      iex> create_subscriber(%{"email" => "user@example.com"})
      {:ok, %Subscriber{email: "user@example.com"}}

      iex> create_subscriber(%{"email" => "invalid"})
      {:error, %Ecto.Changeset{}}
  """
  def create_subscriber(attrs) do
    attrs = Map.put(attrs, "confirmation_token", generate_token())

    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, subscriber} ->
        send_confirmation_email(subscriber)
        {:ok, subscriber}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp send_confirmation_email(subscriber) do
    confirmation_url =
      Phoenix.VerifiedRoutes.url(~p"/confirm/#{subscriber.confirmation_token}")

    SubscriberNotifier.deliver_confirmation_instructions(subscriber, confirmation_url)
  end

  def get_subscriber_by_email(email) do
    Repo.get_by(Subscriber, email: email)
  end

  def confirm_subscriber(token) do
    from(s in Subscriber, where: s.confirmation_token == ^token)
    |> Repo.one()
    |> case do
      nil ->
        {:error, "Invalid token"}

      subscriber ->
        subscriber
        |> Ecto.Changeset.change(confirmed_at: DateTime.utc_now(:second))
        |> Repo.update()
    end
  end

  def change_subscriber(subscriber, attrs \\ %{}) do
    Subscriber.changeset(subscriber, attrs)
  end

  defp generate_token do
    :crypto.strong_rand_bytes(32) |> Base.encode64()
  end
end
