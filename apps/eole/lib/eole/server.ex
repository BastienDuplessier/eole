defmodule Eole.Server do
  use GenServer
  alias Eole.Account

  defstruct [:accounts]

  def start_link do
    GenServer.start_link(__MODULE__, %__MODULE__{accounts: %{}}, [])
  end

  def debit(pid, params) do
    GenServer.call(pid, {:debit, params})
  end

  def handle_call({:debit, params}, _pid, state) do
    accounts = Account.debit(state.accounts, params)
    {:reply, {:ok, "Debited"}, %__MODULE__{state | accounts: accounts}}
  end
end
