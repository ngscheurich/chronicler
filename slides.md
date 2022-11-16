# Link, Monitors, and You

---

## Elixir Fundamentals

**Charting the Course:**

- [x] Processes
- [ ] Links and Monitors
- [ ] GenServers
- [ ] Supervisors

**See:** https://github.com/nathanl/demos/blob/main/README.md#planned-topics

---

## Previously, on Elixir Tech Hour…

Processes:

- Are lightweight units of concurrency in the BEAM
- Are isolated and communicate via message-passing
- Use `send/2` to send messages to processes
- Store messages in a FIFO queue called a mailbox
- Use `receive/1` to process messages in their mailbox
- Maintain state using recursion
- Schedules process execution to give fair access to CPU(s)

### Example: Spawning a Process

```elixir
pid = spawn(fn ->
  receive do
    :hello ->
      IO.puts("World")

    num when is_integer(num) ->
      IO.puts(num * num)

    {:ping, from} ->
      IO.puts("Replying to #{inspect(from)}")
      send(from, :pong)

    _message ->
      IO.puts(:stderr, "Unexpected")
  after
    3_000 -> IO.puts("See ya")
  end)
end
```

---

## The Secret Language of Exit Signals

When a process dies, it emits an exit signal.

- The process has completely its job and has left town on good terms (`:normal`)
- The process was **forcefully terminated** (`:kill`)
- An exception was raised

**See:**
- https://crypt.codemancers.com/posts/2016-01-24-understanding-exit-signals-in-erlang-slash-elixir/
- https://hexdocs.pm/elixir/main/Process.html#exit/2

---

## Linking: Let Us All Die Together

Use `spawn_link/1` to link two processes:

```elixir
a = spawn_link(fn -> receive do _ -> :a end end)
b = spawn_link(fn -> receive do _ -> :b end end)
```

This **bidirectionally** links `a` and `b` with the calling process:

```
~~~graph-easy --as=boxart
[ a ] <- link -> [ self() ] <- link -> [b]
~~~
```

Exit signals will now be propogated along the chain.

---

## It’s a Trap!

While exits are being trapped, exit signals are converted to ordinary messages.

Enable exit trapping with `Process.flag/2`:

```exit
Process.flag(:trap_exit, true)
```

Exit message format:

```elixir
{:EXIT, from, reason}
``` 

**See:**
- https://hexdocs.pm/elixir/1.14.0/Process.html#flag/2
- https://www.erlang.org/doc/man/erlang.html#process_flag-2
