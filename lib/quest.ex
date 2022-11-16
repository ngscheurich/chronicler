defmodule Chronicler.Quest do
  alias __MODULE__
  alias Chronicler.Messenger

  @frequency 1000

  defstruct [:title, danger: 3, duration: 3000]

  def loop(%Quest{} = quest) do
    receive do
      :embark ->
        message(quest, :embark)
        tick(quest)

      :tick ->
        tick(quest)

      :inspect ->
        quest |> dbg() |> loop()
    end
  end

  defp message(%{title: title}, :embark) do
    msg = "📯 Quest underway: “#{title}”"
    Messenger.out(msg)
  end

  defp message(%{title: title}, :success) do
    msg = "🎉 Quest complete: “#{title}”"
    Messenger.out(msg)
  end

  defp message(%{title: title}, :failure) do
    msg = "💀 Quest failed: “#{title}”"
    Messenger.out(msg)
  end

  defp tick(%{duration: duration} = quest) do
    tempt_fate(quest)

    case duration - @frequency do
      num when num <= 0 ->
        message(quest, :success)
        Process.exit(self(), :normal)

      num ->
        Process.send_after(self(), :tick, @frequency)
        loop(%{quest | duration: num})
    end
  end

  defp tempt_fate(quest) do
    roll = Enum.random(1..20)

    if roll + quest.danger >= 20 do
      message(quest, :failure)
      Process.exit(self(), :ill_fated)
    end
  end
end
