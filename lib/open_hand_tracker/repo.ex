defmodule OpenHandTracker.Repo do
  use Ecto.Repo,
    otp_app: :open_hand_tracker,
    adapter: Ecto.Adapters.MyXQL
end
