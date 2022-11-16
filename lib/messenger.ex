defmodule Chronicler.Messenger do
  alias Chronicler.Messengers.{Console, File}

  @callback init() :: :ok
  @callback out(String.t()) :: :ok

  @messengers [Console, File]

  def init do
    for messenger <- @messengers do
      messenger.init()
    end
  end

  def out(term) do
    for messenger <- @messengers do
      messenger.out(term)
    end
  end
end
