defmodule EoleTest do
  use ExUnit.Case
  doctest Eole

  test "debit small amount" do
    assert Eole.debit(%{iban: "GB87BARC20658244971655", amount: 100}) == :ok
  end

  test "debit big amount amount" do
    assert Eole.debit(%{iban: "FR7630001007941234567890185", amount: 10000000}) == :ok
  end
end
