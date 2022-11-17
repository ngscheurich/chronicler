defmodule Chronicler.Chronicle do
  alias __MODULE__
  alias Chronicler.Quest

  defstruct initialized?: false, quests: %{}

  def loop(%Chronicle{} = chronicle) do
    Process.flag(:trap_exit, true)

    chronicle = init(chronicle)

    receive do
      :embark ->
        embark(chronicle)

      {:EXIT, pid, :normal} ->
        remove_quest(chronicle, pid)

      {:EXIT, pid, :ill_fated} ->
        restart_quest(chronicle, pid)

      :inspect ->
        chronicle |> dbg() |> loop()
    end
  end

  defp init(%{initialized?: true} = chronicle) do
    chronicle
  end

  defp init(chronicle) do
    quests =
      Map.new(chronicle.quests, fn quest ->
        pid = spawn_link(fn -> Quest.loop(quest) end)
        {pid, quest}
      end)

    %{chronicle | quests: quests, initialized?: true}
  end

  defp embark(chronicle) do
    for {pid, _} <- chronicle.quests do
      send(pid, :embark)
    end

    loop(chronicle)
  end

  defp remove_quest(chronicle, pid) do
    quests = Map.delete(chronicle.quests, pid)

    unless quests == %{} do
      loop(%{chronicle | quests: quests})
    end
  end

  defp restart_quest(chronicle, pid) do
    quest = chronicle.quests[pid]
    new_pid = spawn_link(fn -> Quest.loop(quest) end)

    quests =
      chronicle.quests
      |> Map.delete(pid)
      |> Map.put(new_pid, quest)

    send(new_pid, :embark)

    loop(%{chronicle | quests: quests})
  end
end
