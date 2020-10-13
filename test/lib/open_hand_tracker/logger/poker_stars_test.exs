defmodule OpenHandTracker.Logger.PokerStarsTest do
  use OpenHandTracker.DataCase

  alias OpenHandTracker.Logger.PokerStars
  test "create config" do
    config = PokerStars.Config.new("./sample/PokerStars/HandHistory")
    assert config.base_path == "./sample/PokerStars/HandHistory"
    assert config.handhistory_path == "./sample/PokerStars/HandHistory/boorian"
    assert config.account == "boorian"
  end
end
