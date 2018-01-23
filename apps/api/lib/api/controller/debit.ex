defmodule API.Controller.Debit do
  use API.Controller

  def create(conn) do
    Eole.debit(%{iban: conn.params["iban"], amount: conn.params["amount"]})

    render(conn, API.View.Debit, "create.json", 200, %{})
  end
end
