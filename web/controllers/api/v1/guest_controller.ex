defmodule Guests.API.V1.GuestController do
  require Logger
  
  use Guests.Web, :controller

  alias Guests.{Guest}

  def index(conn, _params) do
    guests = Repo.all(Guest)
    render(conn, "index.json", guests: guests)
  end

  def create(conn, %{"guest" => guest_params}) do
      changeset = Guest.changeset(%Guest{}, guest_params)

      case Repo.insert(changeset) do
        {:ok, guest} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", api_v1_guest_path(conn, :show, guest))
          |> render("show.json", guest: guest)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Guest.ChangesetView, "error.json", changeset: changeset)
      end
    end

  def show(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)
    render(conn, "show.json", guest: guest)
  end

  def update(conn, %{"id" => id, "guest" => guest_params}) do
    guest = Repo.get!(Guest, id)
    changeset = Guest.changeset(guest, guest_params)

    case Repo.update(changeset) do
      {:ok, guest} ->
        render(conn, "show.json", guest: guest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Guest.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    guest = Repo.get!(Guest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(guest)

    send_resp(conn, :no_content, "")
  end

   def replies(conn, %{"guest" => guest_params}) do
       event_id = "a0ac6584-31a8-4a47-865c-df16ca313739"

      # NOTE: hard code event id for demo
      Map.put(guest_params, :event_id, event_id)
      changeset = Guest.changeset(%Guest{}, guest_params)

      case Repo.insert(changeset) do
        {:ok, guest} ->
          Guests.Endpoint.broadcast("replies:#{guest.event_id}", "new:reply", guest)
          conn
          |> put_flash(:info, "Guest created successfully.")
          |> redirect(to: guest_path(conn, :index))
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Guest.ChangesetView, "error.json", changeset: changeset)
      end
    end

end
