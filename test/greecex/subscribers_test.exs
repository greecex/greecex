defmodule Greecex.SubscribersTest do
  use Greecex.DataCase

  alias Greecex.Subscribers
  alias Greecex.Subscribers.Subscriber

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

    test "enforces unique email addresses" do
      assert {:ok, %Subscriber{}} = Subscribers.create_subscriber(@valid_attrs)
      assert {:error, changeset} = Subscribers.create_subscriber(@valid_attrs)
      assert "has already been taken" in errors_on(changeset).email
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
end
