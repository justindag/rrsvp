defmodule Guests.GuestTest do
  use Guests.ModelCase

  alias Guests.Guest

  @valid_attrs %{additional_guests: 42, email: "some content", name: "some content", phone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Guest.changeset(%Guest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Guest.changeset(%Guest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
