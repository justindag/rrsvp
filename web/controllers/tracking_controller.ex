defmodule Guests.TrackingController do
  use Guests.Web, :controller

  alias Guests.Guest

  def index(conn, _params) do
    event =  %{id: "a0ac6584-31a8-4a47-865c-df16ca313739", name: "Best Event Ever"}
    guests = Repo.all(Guest)
    render(conn, "index.html", event: event, guests: guests)
  end
end
