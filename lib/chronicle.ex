defmodule Chronicler.Chronicle do
  alias __MODULE__
  alias Chronicler.Quest

  defstruct initialized?: false, quests: %{}

  defp init(%{initialized?: true} = chronicle) do
    chronicle
  end

  defp init(chronicle) do
    quests =
      Map.new(chronicle.quests, fn quest ->
        pid = spawn(fn -> Quest.loop(quest) end)
        {pid, quest}
      end)

    %{chronicle | quests: quests, initialized?: true}
  end

  def loop(%Chronicle{} = chronicle) do
    chronicle = init(chronicle)

    receive do
      :embark ->
        embark(chronicle)

      :inspect ->
        chronicle |> dbg() |> loop()
    end
  end

  defp embark(chronicle) do
    for {pid, _} <- chronicle.quests do
      send(pid, :embark)
    end

    loop(chronicle)
  end
end
