defmodule OpenHandTracker.Repo.Migrations.CreateHandHistories do
  use Ecto.Migration

  def change do
    create table(:hand_histories) do
      add :date, :integer
      add :hand_num, :string
      add :platform, :string
      add :stakes, :string
      add :won, :float
      add :hole_cards, :string
      add :position, :string
      add :rake, :float
      add :pot, :float
      add :raw_text, :string

      timestamps()
    end

  end
end
