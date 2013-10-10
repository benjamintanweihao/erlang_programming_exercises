defmodule RingTwo do

  # TODO: Explicitly pass in m and n?
  def run(m, n, message) do
    start_processes(m, n, message)
  end

  def start_processes(m, n, message) do
    last = Enum.reduce 1..n, self, 
             fn (_,send_to) -> 
               spawn(__MODULE__, :loop, [send_to]) 
             end 
    last <- {:message, message, m}
  end

  def loop(next_pid) do    
    receive do
      {:message, _, 0} ->
        IO.puts "shutting down #{inspect next_pid}"
        next_pid <- {:message, "", 0}
      {:message, message, m} ->
        IO.puts "m: #{m}. next_pid: #{inspect next_pid}"
        next_pid <- {:message, message, m-1}
        loop(next_pid)
    end
  end
    
end
