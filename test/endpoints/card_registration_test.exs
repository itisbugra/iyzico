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

    {:ok, _card, metadata} =
      create_card(card, "external_id", "conversation_id", "test@mail.com")

    assert metadata.succeed?
  end

  test "add registers a card" do
    card =
      %Card{
        holder_name: "Buğra Ekuklu",
        number: "5526080000000006",
        exp_year: 19,
        exp_month: 08,
        cvc: 543,
        registration_alias: "Buğra's first credit card"
      }

    {:ok, card, metadata} =
      create_card(card, "external_id", "conversation_id", "test@mail.com")

    assert metadata.succeed?
    assert card

    card_user_key = card.user_key

    new_card =
      %Card{
        holder_name: "Buğra Ekuklu",
        number: "4603450000000000",
        exp_year: 19,
        exp_month: 08,
        cvc: 543,
        registration_alias: "Buğra's second credit card"
      }

    {:ok, _new_card, metadata} =
      add_create_card(new_card, "conversation_id", card_user_key)

    assert metadata.succeed?
  end

  test "retrieves cards of a user" do
    {:ok, _cards, metadata} =
      retrieve_cards("8Fji9iMAKOuIKYX7OtlfGP3MqHc=", "123456789")

    assert metadata.succeed?
  end

  test "deletes a card of a user" do
    card =
      %Card{
        holder_name: "Abdulkadir Dilsiz",
        number: "5528790000000008",
        exp_year: 19,
        exp_month: 08,
        cvc: 543,
        registration_alias: "Kadir's credit card"
      }

    {:ok, card, metadata} =
      create_card(card, "external_id", "conversation_id", "test@mail.com")

    assert metadata.succeed?

    {:ok, metadata} =
      delete_card(card.user_key, card.token, "123456789")

    assert metadata.succeed?
  end
end
