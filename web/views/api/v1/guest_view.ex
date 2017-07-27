defmodule Guests.API.V1.GuestView do
    use Guests.Web, :view

    def render("index.json", %{guests: guests}) do
      %{data: render_many(guests, __MODULE__, "guest.json")}
    end

    def render("show.json", %{guest: guest}) do
      %{data: render_one(guest, __MODULE__, "guest.json")}
    end

    def render("guest.json", %{guest: guest}) do
      %{id:                 guest.id,
        name:               guest.name,
        email:              guest.email,
        status:             guest.status,
        phone:              guest.phone,
        additional_guests:  guest.additional_guests,
        event_id:           guest.event_id,
        account_id:         guest.account_id,
      }
    end
end