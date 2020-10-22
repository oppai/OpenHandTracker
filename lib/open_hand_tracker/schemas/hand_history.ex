defmodule OpenHandTracker.Schemas.HandHistory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hand_histories" do
    field :date, :integer
    field :hand_num, :string
    field :hole_cards, :string
    field :platform, :string
    field :position, :string
    field :pot, :float
    field :rake, :float
    field :raw_text, :string
    field :stakes, :string
    field :won, :float

    timestamps()
  end

  @doc false
  def changeset(hand_history, attrs) do
    hand_history
    |> cast(attrs, [:date, :hand_num, :platform, :stakes, :won, :hole_cards, :position, :rake, :pot, :raw_text])
    |> validate_required([:date, :hand_num, :platform, :stakes, :won, :hole_cards, :position, :rake, :pot, :raw_text])
  end
end
