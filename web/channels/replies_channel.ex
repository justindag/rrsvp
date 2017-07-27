defmodule Guests.RepliesChannel do
  use Phoenix.Channel
  import Ecto.Query, only: [from: 1, from: 2]

  alias Guests.API.V1.GuestView
  alias Guests.{Repo, Guest}

  def join("replies:" <> event_id, _params, socket) do
    IO.puts "-------------- JOIN -- Event ID: #{event_id}"
#    last_seen_id = params["last_seen_id"] || 0

#and g.id > ^last_seen_id

    guests = Repo.all(
           from g in Guest,
         where: g.event_id == ^event_id ,
      order_by: [asc: g.id],
         limit: 200
    )

    resp = %{guests: Phoenix.View.render_many(guests, GuestView,
                                                   "guest.json")}
    {:ok, resp, assign(socket, :event_id, event_id)}

  end

  def handle_in("new:reply", params, socket) do

    IO.puts ("-------------- HANDLE IN 'new:reply' #{inspect(params)}")

    changeset = Guest.changeset(%Guest{}, params)

    case Repo.insert(changeset) do
      {:ok, guest} ->
        broadcast! socket, "new:reply", %{
                  id: guest.id,
                  name: guest.name,
                  status: guest.status,
                  email: guest.email,
                  phone: guest.phone
                }
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

#  def handle_out("new:reply", payload, socket) do
#    IO.puts ("-------------- HANDLE OUT 'new:reply' #{inspect(payload)}")
#    push socket, "new:reply", payload
#    {:noreply, socket}
#  end

end