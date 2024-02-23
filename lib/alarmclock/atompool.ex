defmodule Alarmclock.Atompool do
  @moduledoc """
  use existing atom or generate a new one
  """
  use GenServer

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:alloc, _from, state) do
    if state == [] do
      atom =
        :crypto.hash(:blake2b, "#{System.os_time()}")
        |> binary_slice(0..7)
        |> Base.encode16()
        |> String.to_atom()
      {:reply, atom, state}
    else
      {:reply, hd(state), tl(state)}
    end
  end

  @impl true
  def handle_cast({:dealloc, atom}, state) do
    {:noreply, [atom | state]}
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def alloc(), do: GenServer.call(__MODULE__, :alloc)

  def dealloc(atom), do: GenServer.cast(__MODULE__, {:dealloc, atom})
end
