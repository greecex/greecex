defmodule Greecex.SubscribersTest do
  use Greecex.DataCase

  alias Greecex.Subscribers
  alias Greecex.Subscribers.Subscriber

  import Swoosh.TestAssertions
  use Phoenix.VerifiedRoutes, endpoint: GreecexWeb.Endpoint, router: GreecexWeb.Router

  def setup do
    :ets.delete_all_objects(Greecex.RateLimit)
  end

  describe "create_subscriber/1" do
    @valid_attrs %{
      "email" => "test@example.com",
      "city" => "Athens",
      "elixir_experience" => "I am experienced",
      "willing_to_coorganize" => true
    }

    test "creates subscriber with valid attributes" do
      assert {:ok, %Subscriber{} = subscriber} = Subscribers.create_subscriber(@valid_attrs)
      assert subscriber.email == "test@example.com"
      assert subscriber.city == "Athens"
      assert subscriber.elixir_experience == "I am experienced"
      assert subscriber.willing_to_coorganize == true
      assert subscriber.confirmation_token != nil
    end

    test "fails with invalid attributes" do
      assert {:error, %Ecto.Changeset{}} = Subscribers.create_subscriber(%{})
    end
  end

  describe "get_subscriber_by_email/1" do
    test "returns subscriber when exists" do
      {:ok, subscriber} = Subscribers.create_subscriber(@valid_attrs)
      assert found = Subscribers.get_subscriber_by_email(subscriber.email)
      assert found.id == subscriber.id
    end

    test "returns nil when subscriber doesn't exist" do
      assert is_nil(Subscribers.get_subscriber_by_email("nonexistent@example.com"))
    end
  end

  describe "confirm_subscriber/1" do
    test "confirms subscriber with valid token" do
      {:ok, subscriber} = Subscribers.create_subscriber(@valid_attrs)
      assert {:ok, confirmed} = Subscribers.confirm_subscriber(subscriber.confirmation_token)
      assert confirmed.confirmed_at != nil
    end

    test "returns error with invalid token" do
      assert {:error, "Invalid token"} = Subscribers.confirm_subscriber("invalid-token")
    end
  end

  test "email is sent to the subscriber" do
    email = "test@example.com"
    subscriber = %{"email" => email, "city" => "Agrinio"}
    {:ok, subscriber} = Subscribers.create_subscriber(subscriber)

    to = [{email, email}]
    subject = "Thank you for joining Greece |> Elixir"

    confirmation_url =
      Phoenix.VerifiedRoutes.url(~p"/confirm/#{subscriber.confirmation_token}")

    text_body = """
    Hi #{subscriber.email},

    Thank you for joining Greece |> Elixir!

    Can you please confirm your email address by clicking on the link below?

    #{confirmation_url}

    Cheers,
    The Greece |> Elixir Team
    """

    assert_email_sent(to: to, subject: subject, text_body: text_body)
  end

  test "email is sent to an existing subscriber with a new token on repeat submission" do
    email = "repeat@example.com"
    subscriber_attrs = %{"email" => email, "city" => "Agrinio"}

    # First submission: create the subscriber
    {:ok, initial_subscriber} = Subscribers.create_subscriber(subscriber_attrs)
    initial_token = initial_subscriber.confirmation_token

    # Email details (assuming SubscriberNotifier mimics your original test)
    to = [{email, email}]
    subject = "Thank you for joining Greece |> Elixir"

    assert_email_sent(
      to: to,
      subject: subject,
      text_body:
        generate_text_body(
          email,
          Phoenix.VerifiedRoutes.url(~p"/confirm/#{initial_token}")
        )
    )

    # Second submission: same email
    {:ok, updated_subscriber} = Subscribers.create_subscriber(subscriber_attrs)

    # Check that the token changed
    new_token = updated_subscriber.confirmation_token
    assert new_token != initial_token, "Expected a new confirmation token for repeat submission"

    assert_email_sent(
      to: to,
      subject: subject,
      text_body:
        generate_text_body(
          email,
          Phoenix.VerifiedRoutes.url(~p"/confirm/#{new_token}")
        )
    )
  end

  defp generate_text_body(email, confirmation_url) do
    """
    Hi #{email},

    Thank you for joining Greece |> Elixir!

    Can you please confirm your email address by clicking on the link below?

    #{confirmation_url}

    Cheers,
    The Greece |> Elixir Team
    """
  end
end
