defmodule Guests.Guest do
  use Guests.Web, :model

  schema "guests" do
    field :name, :string
    field :status, :string
    field :email, :string
    field :phone, :string
    field :additional_guests, :integer
    field :event_id, :string
    field :account_id, :string
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :status, :name, :email, :phone, :additional_guests, :event_id, :account_id])
    |> validate_required([:name])
  end
end
