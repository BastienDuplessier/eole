defmodule Eole.Server do
  use GenServer
  alias Eole.Account

  defstruct [:accounts]

  def start_link do
    GenServer.start_link(__MODULE__, %__MODULE__{accounts: %{}}, name: :server)
  end

  def debit(params) do
    GenServer.cast(:server, {:debit, params})
  end

  def handle_cast({:debit, params}, state) do
    accounts = Account.debit(state.accounts, params)
    {:noreply, %__MODULE__{state | accounts: accounts}}
  end
end
