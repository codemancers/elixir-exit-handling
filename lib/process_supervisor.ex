defmodule ProcessSupervisor do
  use Supervisor

  def start_link do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [])
    Process.register(pid, :supervisor)
    {:ok, pid}
  end

  def init([]) do
    children = [
      worker(__MODULE__, [], id: :p1, function: :process1),
      worker(__MODULE__, [], id: :p2, function: :process2)
    ]

    supervise(children, strategy: :one_for_one)
  end

  def process1 do
    {:ok, pid} = Task.start_link fn -> Main.listen("supervised process1") end
    Process.register(pid, :supervised_process1)
    {:ok, pid}
  end

  def process2 do
    {:ok, pid} = Task.start_link fn -> Main.listen("supervised process2") end
    Process.register(pid, :supervised_process2)
    {:ok, pid}
  end
end
