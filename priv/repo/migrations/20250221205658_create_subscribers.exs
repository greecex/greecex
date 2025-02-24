defmodule Greecex.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string, null: false
      add :city, :string, null: false
      add :elixir_experience, :text
      add :confirmed_at, :utc_datetime
      add :confirmation_token, :string, null: false
      add :willing_to_coorganize, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:subscribers, [:email])
    create index(:subscribers, [:city])
  end
end
