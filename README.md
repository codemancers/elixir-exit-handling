Exercise to study process death

```
$ iex -S mix

iex> :observer.start
# Check applications in observer
# Right click on processes and send messages or kill them with apt reasons (check lib/main.ex for valid messages)
```

## Observations

|                                                   | Process not trapping exit            | Process trapping exit                                        |
|---------------------------------------------------|--------------------------------------|--------------------------------------------------------------|
| Exception inside process                          | Dies and kills linked processes      | Dies and kills linked processes                              |
| `Process.exit(self, :kill)` inside process        | Dies and kills linked processes      | Dies and kills linked processes                              |
| `Process.exit(self, :normal)` inside process      | Dies, does not kill linked processes | Does not die, receives message `{:EXIT, from, :normal}`      |
| `Process.exit(self, :some_reason)` inside process | Dies and kills linked processes      | Does not die, receives message `{:EXIT, from, :some_reason}` |
| `Process.exit(pid, :kill)` from outside           | Dies and kills linked processes      | Dies and kills linked processes                              |
| `Process.exit(pid, :normal)` from outside         | Does not die, no message received    | Does not die, receives message `{:EXIT, from, :normal}`      |
| `Process.exit(pid, :some_reason)` from outside    | Dies and kills linked processes      | Does not die, receives message `{:EXIT, from, :some_reason}` |
