defmodule RingOne do

  def run do
    run(10, 5, "hello")
  end

  def run(m, n, message) do
    pid = spawn_link(__MODULE__, :start_process, [n-1])
    pid <- {:message, message, m}
  end

  # Process 1
  def start_process(count) do
    pid = spawn_link(__MODULE__, :start_process, [count-1,  self])
    loop(pid)
  end

  # Process N
  def start_process(0, last) do
    loop(last)
  end

  # The rest of the Processes
  def start_process(count, last) do
    pid = spawn_link(__MODULE__, :start_process, [count-1, last])
    loop(pid)
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
