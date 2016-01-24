defmodule Main do
  def start(_type, _args) do
    {:ok, pid} = Task.start_link fn -> link_processes end
    Process.register(pid, :parent)
    {:ok, pid}
  end

  def link_processes do
    ProcessSupervisor.start_link
    {:ok, pid1} = Task.start_link fn -> listen("process1") end
    {:ok, pid2} = Task.start_link fn -> listen("process2") end
    {:ok, pid3} = Task.start_link fn -> trap_exit_and_listen("process trapping exit") end
    Process.register(pid1, :process1)
    Process.register(pid2, :process2)
    Process.register(pid3, :process_trapping_exit)
    listen("parent")
  end

  def listen(name) do
    receive do
      # Messages to be sent using :observer tool
      :exception              -> raise "#{name} going down"
      :kill                   -> Process.exit(self, :kill)
      :normal                 -> Process.exit(self, :normal)
      :reason                 -> Process.exit(self, :dying_for_a_reason)

      # Print :EXIT message if trapping exits
      {:EXIT, _from, reason} -> IO.puts "#{name} got an :exit with reason #{reason}"
      # Print if receiving unhandled messages
      unhandled               -> IO.puts "#{name} got an unhandled message: #{inspect unhandled}"
    end
    listen(name)
  end

  def trap_exit_and_listen(name) do
    Process.flag(:trap_exit, true)
    listen(name)
  end
end
