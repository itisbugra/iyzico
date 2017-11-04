defmodule Iyzico.CardRegistration do
  @moduledoc """
  Provides functions for registering, querying and managing cards registered in
  target platform.
  """
  import Iyzico.Client

  alias Iyzico.AddCardRegistrationRequest
  alias Iyzico.CardRegistrationRequest
  alias Iyzico.CardReference
  alias Iyzico.CardRetrieval
  alias Iyzico.CardRemoval
  alias Iyzico.Metadata

  @default_locale Keyword.get(Application.get_env(:iyzico, Iyzico), :locale, "en")

  @doc """
  Stores a card with a given user key identifier. One can later retrieve or refer
  to the given card with that identifier.
  """
  @spec add_create_card(Iyzico.Card.t, binary, binary, Keyword.t) ::
    {:ok, Iyzico.CardReference.t, Iyzico.Metadata.t} |
    {:error, :invalid_card}
  def add_create_card(card = %Iyzico.Card{}, conversation_id, card_user_key, opts \\ []) do
    add_registration =
      %AddCardRegistrationRequest{
        locale: @default_locale,
        conversation_id: conversation_id,
        card_user_key: card_user_key,
        card: card
      }

    if Luhn.valid? add_registration.card.number do
      case request([], :post, url_for_path("/cardstorage/card"), [], add_registration, opts) do
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
              email: resp["email"]
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

  def add_create_card!(card = %Iyzico.Card{}, conversation_id, card_user_key) do
    case add_create_card(card, conversation_id, card_user_key) do
      {:ok, card_ref, _metadata} ->
        card_ref
      {:error, error} ->
        raise Iyzico.CardRegistrationError, message: error
    end
  end

  @doc """
  Stores a card with given external identifier. One can later retrieve or refer
  to the given card with that identifier.
  """
  @spec create_card(Iyzico.Card.t, binary, binary, binary, Keyword.t) ::
    {:ok, Iyzico.CardReference.t, Iyzico.Metadata.t} |
    {:error, :invalid_card}
  def create_card(card = %Iyzico.Card{}, external_id, conversation_id, email, opts \\ []) do
    registration =
      %CardRegistrationRequest{
        locale: @default_locale,
        conversation_id: conversation_id,
        external_id: external_id,
        email: email,
        card: card
      }

    if Luhn.valid? registration.card.number do
      case request([], :post, url_for_path("/cardstorage/card"), [], registration, opts) do
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

  @doc """
  Invalidates a registration of given card.
  """
  @spec delete_card(binary, binary, binary) ::
    {:ok, Iyzico.Metadata.t} |
    {:error, :not_found}
  def delete_card(user_key, token, conversation_id)
    when is_binary(user_key) and is_binary(token) and
      is_binary(conversation_id) do
    removal =
      %CardRemoval{
        conversation_id: conversation_id,
        user_key: user_key,
        token: token
      }

    case request([], :delete, url_for_path("/cardstorage/card"), [], removal) do
      {:ok, resp} ->
        metadata =
          %Metadata{
            system_time: resp["systemTime"],
            succeed?: resp["status"] == "success",
            phase: nil,
            locale: resp["locale"],
            auth_code: nil
          }

        {:ok, metadata}
      any ->
        any
    end
  end

  @doc """
  Same as `delete_card/1` but raises `Iyzico.CardNotRegisteredError` error if
  card is not registered.
  """
  @spec delete_card!(binary, binary, binary) ::
    no_return
  def delete_card!(user_key, token, conversation_id) do
    case delete_card(user_key, token, conversation_id) do
      {:ok, _metadata} ->
        nil
      {:error, _any} ->
        raise Iyzico.CardNotRegisteredError
    end
  end

  @doc """
  Retrieves all cards of a user.
  """
  @spec retrieve_cards(binary, binary) ::
    {:ok, list, Iyzico.Metadate.t} |
    {:error, atom}
  def retrieve_cards(user_key, conversation_id)
    when is_binary(conversation_id) and is_binary(user_key) do
    card_ret =
      %CardRetrieval{
        conversation_id: conversation_id,
        user_key: user_key
      }

    case request([], :post, url_for_path("/cardstorage/cards"), [], card_ret) do
      {:ok, resp} ->
        list =
          Enum.map(resp["cardDetails"], fn (element) ->
            %CardReference{
              alias: element["cardAlias"],
              assoc: Iyzico.Card.get_card_assoc(element["cardAssociation"]),
              bank_name: element["cardBankName"],
              type: Iyzico.Card.get_card_type(element["cardType"]),
              family: Iyzico.Card.get_card_family(element["cardFamily"]),
              token: element["cardToken"],
              user_key: resp["cardUserKey"]
            }
          end)

        metadata =
          %Metadata{
            system_time: resp["systemTime"],
            succeed?: resp["status"] == "success",
            phase: nil,
            locale: resp["locale"],
            auth_code: nil
          }

        {:ok, list, metadata}
      any ->
        any
    end
  end

  @doc """
  Validates a card, returns `true` value if card is valid. Otherwise, returns `false`.
  """
  @spec valid?(Iyzico.Card.t) :: boolean
  def valid?(card = %Iyzico.Card{}) do
    Luhn.valid?(card.number)
  end
end
