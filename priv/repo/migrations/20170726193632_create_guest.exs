defmodule Guests.Repo.Migrations.CreateGuest do
  use Ecto.Migration

  def change do
    create table(:guests) do
      add :name, :string
      add :status, :string
      add :email, :string
      add :phone, :string
      add :additional_guests, :integer
      add :event_id, :string
      add :account_id, :string
      timestamps
    end

    create unique_index(:guests, :id, name: :id_idx)
    create index(:guests, :event_id, name: :event_id_idx)
    create index(:guests, [:email, :event_id], name: :event_id_email_idx)
  end
end
