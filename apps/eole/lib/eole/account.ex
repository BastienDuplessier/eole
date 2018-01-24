defmodule Eole.Account do
  @moduledoc """
  Documentation for Eole.Account.
  """

  alias Eole.Debit

  # Time manipulation
  import Kronos

  # Log
  require Logger

  @doc """
  Create a new debit, and insert into account in accounts list

  """
  def debit(accounts, params) do
    iban = params[:iban]
    account = accounts |> Map.get(iban, []) |> update(params) |> check(iban)
    accounts |> Map.merge(%{iban => account})
  end

  @doc """
  Update account with new debit

  """
  def update(account, params) do
    [Debit.build(params) | account]
  end

  @doc """
  Check if account had more than 10k€ of debit last 20 minutes. If true, output a warning log

  """
  def check(account, iban) do
    ago = twenty_min_ago()
    account
    |> Enum.filter(fn(deb) -> deb.time |> Kronos.new! > ago end)
    |> List.foldl(0, fn(deb, sum) -> sum + deb.amount end)
    |> warn(account, iban)
  end

  @doc """
  Returns Kronow entity of 20 minutes ago

  """
  def twenty_min_ago do
    use Kronos.Infix
    Kronos.now - ~t(20)minute
  end

  @doc """
  Outputs a warning if amount is over 10k€ and returns account everytime

  """
  def warn(amount, account, iban) do
    if amount > 1_000_000 do # 10 000€ as euro-cents
      Logger.warn fn ->
        "There was more than 10 000€ of debit on account #{iban} recently"
      end
    end
    account
  end

end
