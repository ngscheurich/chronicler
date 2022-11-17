# 🛡 Chronicler

An app that uses Erlang processes to model **epic quests**.

---

## 🧪 Elixir Fundamentals

**Charting the Course:**

- [x] Processes
- [ ] Links and Monitors
- [ ] GenServers
- [ ] Supervisors

**See:** https://github.com/nathanl/demos/blob/main/README.md#planned-topics

---

## 🕙 Previously, on Elixir Tech Hour…

Processes:

- Are lightweight units of concurrency in the BEAM
- Are isolated and communicate via message-passing
- Use `send/2` to send messages to processes
- Store messages in a FIFO queue called a mailbox
- Use `receive/1` to process messages in their mailbox
- Maintain state using recursion
- Are scheduled to get fair access to CPU(s)

---

## 🤫 The Secret Language of Exit Signals

When a process dies, it emits an exit signal.

**Types of exit signals:**

- The process has completed its job (`:normal`)
- The process was forcefully terminated (`:kill`)
- The process has crashed, e.g. an exception was raised

**See:**
- https://crypt.codemancers.com/posts/2016-01-24-understanding-exit-signals-in-erlang-slash-elixir/
- https://hexdocs.pm/elixir/main/Process.html#exit/2

---

## 🔗 Linking

Use `spawn_link/1` or `Process.link/1` to link two processes:

```elixir
a = spawn_link(fn -> receive do _ -> :a end end)
b = spawn(fn -> receive do _ -> :b end end)
Process.link(b)
```

This **bidirectionally** links `a` and `b` with the calling process:

```
~~~graph-easy --as=boxart
[ a ] <- link -> [ self() ] <- link -> [b]
~~~
```

Exit signals will now be propogated along the chain, which allows your systems to _fail together_ and _fail fast_.

**See:**
- https://www.erlang.org/doc/man/erlang.html#spawn_link-4
- https://hexdocs.pm/elixir/1.14.0/Process.html#link/1

---

## ⛔ It’s a Trap!

While exits are being trapped, exit signals are converted to ordinary messages.

Enable exit trapping with `Process.flag/2`:

```exit
Process.flag(:trap_exit, true)
```

Exit message format:

```elixir
{:EXIT, from, reason}
``` 

**Note:** The `:kill` signal cannot be trapped if sent directly to a process! It simply ignores your petty, earthly bonds.

**See:**
- https://hexdocs.pm/elixir/1.14.0/Process.html#flag/2
- https://www.erlang.org/doc/man/erlang.html#process_flag-2

---

## 👁️ Monitoring

Use `spawn_monitor/1` or `Process.monitor/1` to have the caller to monitor another process.

```elixir
a = spawn_monitor(fn -> receive do _ -> :a end end)
b = spawn(fn -> receive do _ -> :b end end)
Process.monitor(b)
```

The calling process will now receive a `:DOWN` message if `a` or `b` dies.

```
~~~graph-easy --as=boxart
[self()] -> [a]
[self()] -> [b]
~~~
```

The message will look like:

```elixir
{:DOWN, reference, :process, from, reason}
```

**See:**

- https://www.erlang.org/doc/man/erlang.html#spawn_monitor-1
- https://hexdocs.pm/elixir/1.14.0/Process.html#monitor/1

---

## 👋 Fin

The End.
