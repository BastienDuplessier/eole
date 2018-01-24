defmodule Eole.AccountTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  doctest Eole.Account

  describe "when account is new" do
    setup do
      {:ok, accounts: %{}}
    end

    test "can debit", %{accounts: accounts} do
      result = Eole.Account.debit(accounts, %{iban: "FR7630001007941234567890185",
                                              amount: 1000})
      assert %{"FR7630001007941234567890185" => [%Eole.Debit{amount: 1000, id: _id, time: _time}]} = result
    end
  end

  describe "when account is not new" do
    setup do
      {:ok, accounts: %{"FR7630001007941234567890185" => [%Eole.Debit{amount: 1000, id: "12804ada-b796-480a-b3d2-f87247c87475", time: 1500000000}]}}
    end

    test "can debit", %{accounts: accounts} do
      result = Eole.Account.debit(accounts, %{iban: "FR7630001007941234567890185",
                                              amount: 1000})
      assert %{"FR7630001007941234567890185" => [
        %Eole.Debit{amount: 1000, id: _id, time: _time},
        %Eole.Debit{amount: 1000, id: "12804ada-b796-480a-b3d2-f87247c87475", time: 1500000000}]
      } = result
    end
  end

  describe "when there was already more than 10k euros debited July 14th" do
    setup do
      {:ok, accounts: %{"FR7630001007941234567890185" => [%Eole.Debit{amount: 1000000000, id: "12804ada-b796-480a-b3d2-f87247c87475", time: 1500000000}]}}
    end

    test "does not output warn log", %{accounts: accounts} do
      assert capture_log(fn ->
        Eole.Account.debit(accounts, %{iban: "FR7630001007941234567890185",
                                       amount: 1000})
      end) == ""
    end
  end

  describe "when there was already more than 10k euros debited just now" do
    setup do
      {:ok,
       accounts: Eole.Account.debit(%{}, %{iban: "FR7630001007941234567890185",
                                           amount: 10000000000})}
    end

    test "output warn log", %{accounts: accounts} do
      message = "[warn]  There was more than 10 000€ of debit on account FR7630001007941234567890185 recently"
      assert capture_log(fn ->
        Eole.Account.debit(accounts, %{iban: "FR7630001007941234567890185",
                                       amount: 1000})
      end) =~ message
    end
  end
end
