defmodule API.View.Debit do
  def render("create.json", _param) do
    %{message: "Debit registered"}
  end
end
