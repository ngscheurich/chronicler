defmodule Chronicler.Messengers.Console do
  @behaviour Chronicler.Messenger

  @impl true
  def init, do: :ok

  @impl true
  def out(term), do: IO.puts(term)
end
