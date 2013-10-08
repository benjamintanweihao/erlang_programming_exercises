defmodule Echo do

  def start do
    pid = spawn(__MODULE__, :loop, [])
    Process.register(pid, :echo) 
  end

  def print(msg) do
    IO.puts "Received: #{msg}"
  end

  def loop do
    receive do
      {:print, msg} -> 
        print(msg)
        loop
      :stop -> true
    end
  end

end
