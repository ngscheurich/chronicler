defmodule Chronicler.Messengers.File do
  @behaviour Chronicler.Messenger
  @file_path "messages.log"

  @impl true
  def init, do: ensure_file()

  @impl true
  def out(term) do
    now = DateTime.utc_now()
    contents = File.read!(@file_path)
    File.write!(@file_path, contents <> "\n[#{now}] #{term}")
  end

  defp ensure_file do
    unless File.exists?(@file_path) do
      File.touch!(@file_path)
    end

    File.write!(@file_path, "")
  end
end
