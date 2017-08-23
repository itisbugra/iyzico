defmodule Iyzico.CardRegistration do
  @moduledoc """
  Provides functions for registering, querying and managing cards registered in target platform.
  """
  import Iyzico.Client

  alias Iyzico.CardRegistrationRequest
  alias Iyzico.CardReference
  alias Iyzico.Metadata

  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  @doc """
  Stores a card with given external identifier. One can later retrieve or refer to the given card with that identifier.
  """
  @spec create_card(Iyzico.Card.t, binary, binary, binary) ::
    {:ok, Iyzico.CardReference.t, Iyzico.Metadata.t} |
    {:error, :invalid_card}
  def create_card(card = %Iyzico.Card{}, external_id, conversation_id, email) do
    registration =
      %CardRegistrationRequest{
        locale: @default_locale,
        conversation_id: conversation_id,
        external_id: external_id,
        email: email,
        card: card
      }

    if Luhn.valid? registration.card.number do
      case request([], :post, url_for_path("/cardstorage/card"), [], registration) do
        {:ok, resp} ->
          card_ref =
            %CardReference{
              user_key: resp["cardUserKey"],
              token: resp["cardToken"],
              alias: resp["cardAlias"],
              card: card,
              type: Iyzico.Card.get_card_type(resp["cardType"]),
              assoc: Iyzico.Card.get_card_assoc(resp["cardAssociation"]),
              family: Iyzico.Card.get_card_family(resp["cardFamily"]),
              bank_name: resp["cardBankName"],
              email: email
            }

          metadata =
            %Metadata{
              system_time: resp["systemTime"],
              succeed?: resp["status"] == "success",
              phase: nil,
              locale: resp["locale"],
              auth_code: nil
            }

          {:ok, card_ref, metadata}
        any ->
          any
      end
    else
      {:error, :invalid_card}
    end
  end

  def create_card!(card = %Iyzico.Card{}, external_id, conversation_id, email) do
    case create_card(card, external_id, conversation_id, email) do
      {:ok, card_ref, _metadata} ->
        card_ref
      {:error, error} ->
        raise Iyzico.CardRegistrationError, message: error
    end
  end

  # @doc """
  # Invalidates a registration of given card.
  # """
  # @spec delete_card(Iyzico.Card.t) ::
  #   :ok |
  #   {:error, :not_found}
  # def delete_card(card = %Iyzico.Card{}) do
  #
  # end
  #
  # @doc """
  # Same as `delete_card/1` but raises `Iyzico.CardNotRegistered` error if card is not registered.
  # """
  # @spec delete_card!(Iyzico.Card.t) :: no_return
  # def delete_card!(card = %Iyzico.Card{}) do
  #
  # end
  #
  # @doc """
  # Retrieves all cards of a user.
  # """
  # @spec retrieve_cards() :: list
  # def retrieve_cards() do
  #
  # end
  #
  # def valid?(card = %Iyzico.Card{}) do
  #
  # end
end
