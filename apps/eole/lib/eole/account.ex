defmodule Eole.Account do
  alias Eole.Debit

  # Time manipulation
  import Kronos

  # Log
  require Logger

  def debit(accounts, params) do
    iban = params[:iban]
    account = accounts |> Map.get(iban, []) |> update(params) |> check(iban)
    accounts |> Map.merge(%{iban => account})
  end

  def update(account, params) do
    [Debit.build(params) | account]
  end

  # %{} |> Eole.Account.debit(%{amount: 30, iban: "BAE"})
  def check(account, iban) do
    ago = twenty_min_ago()
    account
    |> Enum.filter(fn(deb) -> deb.time |> Kronos.new! > ago end)
    |> List.foldl(0, fn(deb, sum) -> sum + deb.amount end)
    |> warn(account, iban)
  end

  def twenty_min_ago do
    use Kronos.Infix
    Kronos.now - ~t(20)minute
  end

  def warn(amount, account, iban) do
    if amount > 1_000_000 do # 10 000€ as euro-cents
      Logger.warn fn ->
        "There was more than 10 000€ of debit on account #{iban} recently"
      end
    end
    account
  end

end
