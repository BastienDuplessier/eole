defmodule Eole do
  @moduledoc """
  Documentation for Eole.
  """

  @doc """
  Create a new debit and add it to the corresponding account

  ## Examples

      iex> Eole.debit(%{iban: "GB87BARC20658244971655", amount: 1000})
      :ok

  """
  def debit(%{iban: _iban, amount: _amount} = params) do
    Eole.Server.debit(params)
  end

end
