defmodule OpenHandTrackerWeb.Router do
  use OpenHandTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", OpenHandTrackerWeb do
    pipe_through :api
  end
end
