defmodule Chronicler.Quest do
  alias __MODULE__
  alias Chronicler.Messenger

  @frequency 1000

  defstruct [:title, duration: 3000]

  def loop(%Quest{} = quest) do
    receive do
      :embark ->
        message(quest, :embark)
        Process.sleep(quest.duration)
        message(quest, :success)

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
end
