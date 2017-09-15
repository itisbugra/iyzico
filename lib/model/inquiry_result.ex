defmodule Iyzico.InquiryResult do
  @moduledoc """
  A module representing BIN inquiry results.
  """
  @enforce_keys ~w(card_ref price installment_opts is_secure_payment_mandatory?)a

  defstruct [
    :card_ref,
    :price,
    :installment_opts,
    :is_secure_payment_mandatory?
  ]

  @typedoc """
  Represents a BIN inquiry.

  ## Fields

  - `:card_ref`: The resolved card reference of inquiry.
  - `:price`: Price given to the inquiry.
  - `:installment_opts`: Available installment options on that BIN in given price.
  """
  @type t :: %__MODULE__{
    card_ref: Iyzico.CardReference.t,
    price: number,
    installment_opts: list,
    is_secure_payment_mandatory?: boolean
  }
end
