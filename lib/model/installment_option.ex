defmodule Iyzico.InstallmentOption do
  @moduledoc """
  A module representing installment options to be applied on a payment.
  """
  @enforce_keys ~w(per_month_price stages)a

  defstruct [
    :per_month_price,
    :stages
  ]

  @typedoc """
  Represents an installment option of a payment.

  ## Fields

  - `:per_month_price`: Price to be paid per month.
  - `:stages`: The number of stages incurred.
  """
  @type t :: %__MODULE__{
    per_month_price: number,
    stages: integer
  }

  @doc """
  Returns total price for given installment option.
  """
  @spec get_total_price(Iyzico.InstallmentOption.t) ::
    number
  def get_total_price(opt = %Iyzico.InstallmentOption{}) do
    opt.per_month_price * opt.stages
  end
end
