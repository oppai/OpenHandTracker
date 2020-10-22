defmodule OpenHandTracker.Logger.PokerStars do
  alias OpenHandTracker.Logger.PokerStars

  @handhistory_path "./sample/PokerStars/HandHistory"

  def start() do
    File.ls!(@handhistory_path)
    |> Enum.each(fn account ->
      File.ls!("#{@handhistory_path}/#{account}")
      |> Enum.each(fn file ->
        PokerStars.Parser.import("#{@handhistory_path}/#{account}/#{file}")
      end)
    end)
  end


  defmodule Manager do
    @moduledoc """
    OpenHandTracker.Logger.PokerStars.Manager
    ディレクトリを監視してログファイルが新しく生成されたらWokerにファイル解析を投げる
    """
    # import GenServer

    # def start(log_path) do
    #   if get(log_path) == nil do
    #     {:ok, pid} = PokerStars.Worker.start(log_path)
    #     set(log_path, pid)
    #   end
    # end

    # def stop_all, do: all() |> Enum.each(&stop/1)

    # defp stop(nil), do: nil
    # defp stop(pid) do
    #   PokerStars.Worker.stop(pid)
    #   set(log_path, nil)
    # end

    # def all, do: keys() |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, %{x => get(x)}) end)

    # defp ets_name, do: :log_worker
    # defp get(key), do: Cachex.get(ets_name(), key) |> elem(1)
    # defp set(key, val), do: Cachex.put(ets_name(), key, val)
    # defp keys, do: Cachex.keys(ets_name())
  end

  defmodule Worker do
    @moduledoc """
    OpenHandTracker.Logger.PokerStars.Worker
    ファイルパスを受け取ってファイルのストリームでパースする
    """
    # use GenServer

    # def start(log_path) do
    #   GenServer.start_link(__MODULE__, log_path)
    # end

    # def stop(pid) do
    #   GenServer.cast(pid, :do_stop)
    # end

    # def init(%Target{interval: interval} = target) do
    #   schedule_work(interval)
    #   {:ok, target}
    # end

    # def handle_cast(:do_stop, %Target{} = target) do
    #   IO.puts("#{target.url} is stopped.")
    #   {:stop, :normal, target}
    # end

    # def handle_info(:do_check, %Target{} = target) do
    #   if target.is_active, do: Netcat.Services.Karte.tap(target.id)
    #   schedule_work(target.interval)
    #   {:noreply, target}
    # end

    # defp schedule_work(interval) do
    #   Process.send_after(self(), :do_check, interval * 1000)
    # end
  end

  defmodule Parser do
    defmodule State do
      def parse_init, do: 0
      def parse_hole, do: 1
      def parse_flop, do: 2
      def parse_turn, do: 3
      def parse_river, do: 4
      def parse_summary, do: 5
      def parse_end, do: 6
    end
    
    def import(nil), do: nil
    def import(path) when is_binary(path) do
      File.read!(path)
      |> String.split("\n\n\n\n")
      |> Enum.map(fn one_hand_game ->
        one_hand_game
        |> String.split("\n")
        |> Enum.reduce(game_init(), fn game_line, acc ->
          parsed_line = parse(acc["state"], line)
          %{
            "state" => parsed_line["state"] || acc["state"],
            "players" => merge_players(acc["players"], parsed_line["player"])
            "date" => parsed_line || acc["date"]
          })
        end)
      end)
    end

    defp game_init() do
      %{
        "state" => State.parse_init(),
        "players" => [],
      }
    end

    defp merge_players(acc, nil), do: acc
    defp merge_players(acc, player) do
      Enum.uniq(acc ++ [player])
    end

    @doc """
      %{"state" => xxx} : 存在してなければ現在のstateを継承
    """
    @state_init State.parse_init()
    defp parse(@state_init, "\uFEFF" <> line), do: parse(State.parse_init(), line)
    defp parse(@state_init, line) do
      case line do
        "PokerStars Hand " <> _ ->
          Regex.named_captures(~r/PokerStars Hand #(?<hand_num>\d+):  (?<kind>.+) \((?<stakes>.*)\) - (?<date>\d{4}\/\d{2}\/\d{2} \d{1,2}:\d{2}:\d{2})/, line)
        "Table " <> _ ->
          Regex.named_captures(~r/Table '(?<table_name>[\s\dA-z]+)' (?<stakes>.+) Seat #(?<button_num>\d+) is the button/, line)
        "Seat " <> _ ->
          %{
            "player" => Regex.named_captures(~r/(?<seate_name>Seat (?<seat_num>\d+)): (?<name>[\dA-z\-\s]+) \((?<currency>\$\d+.\d+) in chips\)/, line)
          }
        "*** HOLE CARDS ***" -> %{""}
        _ -> %{"state" => State.parse_hole()}
      end
    end
  end

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
