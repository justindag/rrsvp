defmodule Guests.Router do
  use Guests.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Guests do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/tracking", TrackingController, :index
    resources "/guests", GuestController
  end

  # Other scopes may use custom stacks.
     scope "/api", Guests.API, as: :api do
       pipe_through :api
       scope "/v1", V1, as: :v1 do
          resources "/guests", GuestController, except: [:new, :edit]
       end
     end
end
