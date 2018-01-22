defmodule Eole.Debit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :amount, :integer
    field :time, :time
  end

  def build(params) do
    changeset = changeset(params)

    if changeset.valid? do
      changeset |> apply_changes
    else
      changeset.errors
    end
  end

  defp changeset(params) do
    %__MODULE__{}
    |> cast(params, [:amount])
    |> validate_required([:amount])
    |> put_change(:id, Ecto.UUID.generate)
    |> put_change(:time, :os.system_time(:seconds))
  end
end
