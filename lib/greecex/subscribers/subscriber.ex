defmodule Greecex.Subscribers.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "subscribers" do
    field :email, :string
    field :city, :string
    field :elixir_experience, :string
    field :confirmed_at, :utc_datetime
    field :confirmation_token, :string
    field :willing_to_coorganize, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(email city confirmation_token)a
  @optional_fields ~w(elixir_experience confirmed_at willing_to_coorganize)a

  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end
end
