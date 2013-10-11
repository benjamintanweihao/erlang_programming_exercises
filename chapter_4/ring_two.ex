defmodule RingTwo do

  def run do
    run(10, 5, "hello")
  end

  def run(m, n, message) do
    start_processes(m, n, message)
  end

  def start_processes(m, n, message) do
    last = Enum.reduce 1..n, self, 
             fn (_,send_to) -> 
               spawn_link(__MODULE__, :loop, [send_to]) 
             end 
    last <- {:message, message, m}
    loop(last)
  end

  def loop(next_pid) do
    receive do
      {:message, message, 0} -> 
        IO.puts "#{inspect self} shutting down. next_pid: #{inspect next_pid}."
        next_pid <- {:message, message, 0}
        :ok
      {:message, message, m} -> 
        IO.puts "m: #{m}. self: #{inspect self}. next_pid: #{inspect next_pid}."
        next_pid <- {:message, message, m-1}
        loop(next_pid)
    end
  end
    
end
