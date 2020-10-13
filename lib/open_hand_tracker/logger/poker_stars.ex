defmodule OpenHandTracker.Logger.PokerStars do
  @handhistory_path "./sample/PokerStars/HandHistory"

  defmodule Config do
    defstruct [:base_path, :handhistory_path, :account]
    def new(base_path) when is_binary(base_path) do
      account = account(base_path)
      %__MODULE__{
        base_path: base_path,
        handhistory_path: handhistory_path(base_path, account),
        account: account
      }
    end

    defp account(base_path) do
      File.ls!(base_path) |> List.first()
    end

    defp handhistory_path(base_path, account) do
      "#{base_path}/#{account}"
    end
  end
end
