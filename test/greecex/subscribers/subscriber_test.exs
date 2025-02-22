defmodule Greecex.Subscribers.SubscriberTest do
  use Greecex.DataCase

  alias Greecex.Subscribers.Subscriber

  describe "changeset/2" do
    @valid_attrs %{
      email: "test@example.com",
      city: "Athens",
      confirmation_token: "some-token",
      elixir_experience: "beginner",
      willing_to_coorganize: true
    }

    test "creates valid changeset with required attributes" do
      changeset = Subscriber.changeset(%Subscriber{}, @valid_attrs)
      assert changeset.valid?
    end

    test "requires email, city, and confirmation_token" do
      changeset = Subscriber.changeset(%Subscriber{}, %{})
      refute changeset.valid?

      assert %{
               email: ["can't be blank"],
               city: ["can't be blank"],
               confirmation_token: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email format" do
      attrs = Map.put(@valid_attrs, :email, "invalid-email")
      changeset = Subscriber.changeset(%Subscriber{}, attrs)
      refute changeset.valid?
      assert "must have the @ sign and no spaces" in errors_on(changeset).email

      attrs = Map.put(@valid_attrs, :email, "test with spaces@example.com")
      changeset = Subscriber.changeset(%Subscriber{}, attrs)
      refute changeset.valid?
      assert "must have the @ sign and no spaces" in errors_on(changeset).email
    end

    test "validates email length" do
      attrs = Map.put(@valid_attrs, :email, String.duplicate("a", 150) <> "@example.com")
      changeset = Subscriber.changeset(%Subscriber{}, attrs)
      refute changeset.valid?
      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end
  end
end
