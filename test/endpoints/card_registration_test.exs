defmodule Iyzico.CardRegistrationTest do
  use Iyzico.EndpointCase

  import Iyzico.CardRegistration

  alias Iyzico.Card

  test "registers a card" do
    card =
      %Card{
        holder_name: "Abdulkadir Dilsiz",
        number: "5528790000000008",
        exp_year: 19,
        exp_month: 08,
        cvc: 543,
        registration_alias: "Kadir's credit card"
      }

    {:ok, _payment, metadata} = create_card(card, "external_id", "conversation_id", "test@mail.com")

    assert metadata.succeed?
  end
end
