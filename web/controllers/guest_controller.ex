defmodule Guests.GuestController do
  use Guests.Web, :controller

  alias Guests.Guest

  def index(conn, _params) do
    guests = Repo.all(Guest)
    render(conn, "index.html", guests: guests)
  end

  def new(conn, _params) do
    # NOTE: hard code event for demo
    event =  %{id: "a0ac6584-31a8-4a47-865c-df16ca313739", name: "Best Event Ever"}

    changeset = Guest.changeset(%Guest{})
    render(conn, "new.html", event: event, changeset: changeset)
  end

  def create(conn, %{"guest" => guest_params}) do
    conn |> redirect(to: guest_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    render(conn, "show.html", guest: guest)
  end

  def edit(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest)
    render(conn, "edit.html", guest: guest, changeset: changeset)
  end

  def update(conn, %{"id" => id, "guest" => guest_params}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest, guest_params)

    case Repo.update(changeset) do
      {:ok, guest} ->
        conn
        |> put_flash(:info, "Guest updated successfully.")
        |> redirect(to: guest_path(conn, :show, guest))
      {:error, changeset} ->
        render(conn, "edit.html", guest: guest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(guest)

    conn
    |> put_flash(:info, "Guest deleted successfully.")
    |> redirect(to: guest_path(conn, :index))
  end
end
