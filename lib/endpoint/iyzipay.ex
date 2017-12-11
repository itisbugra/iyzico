defmodule Iyzico.Iyzipay do
  @moduledoc """
  A module containing payment related functions.

  ## Making a payment

  In order to process a payment, one needs to create a `Iyzico.PaymentRequest`
  struct, which consists of a payment card,
  a buyer, two seperate addresses for shipping and billing and basket
  information (aka *items*).
  ```
  payment_request =
    %PaymentRequest{
      locale: @current_locale,
      conversation_id: "123456789",
      price: "0.5",
      paid_price: "0.7",
      currency: :try,
      basket_id: "B67832",
      payment_channel: :web,
      payment_group: :product,
      payment_card: card,
      installment: 1,
      buyer: buyer,
      shipping_address: shipping_address,
      billing_address: billing_address,
      basket_items: [
        binocular_item,
        game_item
      ]
    }
  ```

  With that `Iyzico.PaymentRequest`, it is straightforward to process the
  request.

  ```
  {:ok, payment, metadata} = process_payment_req(payment_request)
  ```

  #### 3D Secure support

  Authenticity of a transaction can be enhanced using *3D Secure* feature,
  which is optional, although some associations might require the use of
  *3D Secure* explicitly.
  *3D Secure* based transaction could performed with
  `process_secure_payment_req/2` function, which is analogical to its insecure
  friend `process_payment_req/3`.

  ## Making a secure payment

  Processing a secure payment is on par with insecure payments, what is more,
  secure payments require a callback URL
  since remote authority will finalize the transaction by making a call to
  given URL.

  #### Instantiation

  ```
  payment_request =
    %SecurePaymentRequest{
      locale: @current_locale,
      conversation_id: "123456789",
      price: "0.5",
      paid_price: "0.7",
      currency: :try,
      basket_id: "B67832",
      payment_channel: :web,
      payment_group: :product,
      payment_card: card,
      installment: 1,
      buyer: buyer,
      shipping_address: shipping_address,
      billing_address: billing_address,
      basket_items: [
        binocular_item,
        game_item
      ],
      callback_url: "https://some.domain.to/be-specified/"
    }

  {:ok, artifact, metadata} = init_secure_payment_req(payment_request)
  ```

  #### Finalization

  ```
  handle =
    %SecurePaymentHandle{
      conversation_id: "123456789",
      payment_id: "10533265",
      conversation_data: "some data"
    }

  {:ok, payment, metadata} = finalize_secure_payment_req(handle)
  ```

  ## Post-payment operations

  After payment is successfully completed, it can be revoked (cancelled) or
  refunded.
  A revoke operation deletes the payment and can be utilized if and only if
  transaction has not reconciliated by the bank, which often happens at the
  end of a day.
  Successful revoke operations are invisible in card statement.

  **Some regulations applied by banks on transactions might restrict
  cancellation operations.**

  Refund operations could also be performed in order to pay back specified
  amount of funds and can be performed in any time, without any restrictions.
  Merchants are able to refund up to full amount of the transaction, and
  able to do it with proportions of the amount.
  Multiple refund operations could be performed by making sequential calls.

  ## Discussion

  Although utilization of *3D secure* featured transactions become overwhelming
  in terms of duration of the payment it is highly discouraged to perform
  insecure transactions directly, especially without concerning about customer's
  consent.
  Secure transactions involve two-factor authentication provided by
  associations, hence displacing the responsibility of
  the developer to be not concerned about authenticity of the credit card
  information.

  ## Common options

  - `:api_key`: API key to be used in authentication, optional. Configuration
  is used instead if not supplied.

  - `:api_secret`: API secret key to be used in authentication. Configuration
  is used instead if not supplied.
  """
  import Iyzico.Client
  import Iyzico.CompileTime
  import Iyzico.ErrorHandler

  alias Iyzico.Payment
  alias Iyzico.Transaction
  alias Iyzico.ConvertedPayout
  alias Iyzico.Metadata
  alias Iyzico.Card
  alias Iyzico.CardReference
  alias Iyzico.SecurePaymentArtifact
  alias Iyzico.RevokePaymentRequest
  alias Iyzico.RefundPaymentRequest

  @type currency :: :try

  @server_ip Keyword.get(Application.get_env(:iyzico, Iyzico), :server_ip, nil)
  static_assert_tuple(@server_ip)

  @doc """
  Processes the given payment request on the remote API.

  ## Options

  See common options.
  """
  @spec process_payment_req(Iyzico.PaymentRequest.t, Keyword.t) ::
    {:ok, Iyzico.Payment.t, Iyzico.Metadata.t} |
    {:error, atom}
  def process_payment_req(payment_request = %Iyzico.PaymentRequest{}, opts \\ []) do
    case request([], :post, url_for_path("/payment/auth"), [], payment_request, opts) do
      {:ok, resp} ->
        if resp["status"] == "success",
          do: serialize_resp(resp),
          else: handle_error(resp)
      any ->
        any
     end
  end

  @doc """
  Same as `process_payment_req/1`, but raises an
  `Iyzico.PaymentProcessingError` exception in case of failure.
  Otherwise returns successfully processed payment.
  """
  def process_payment_req!(payment = %Iyzico.PaymentRequest{}, opts \\ []) do
    case process_payment_req(payment, opts) do
      {:ok, payment, metadata} ->
        {payment, metadata}
      {:error, code} ->
        raise Iyzico.PaymentProcessingError, code: code
    end
  end

  @doc """
  Instantiates the given secure payment request on the remote API.

  ## Options

  See common options.
  """
  @spec init_secure_payment_req(Iyzico.SecurePaymentRequest.t, Keyword.t) ::
    {:ok, Iyzico.SecurePaymentArtifact.t, Iyzico.Metadata.t} |
    {:error, atom}
  def init_secure_payment_req(payment_request = %Iyzico.SecurePaymentRequest{}, opts \\ []) do
    case request([], :post, url_for_path("/payment/3dsecure/initialize"), [], payment_request, opts) do
      {:ok, resp} ->
        secure_payment_artifact =
          %SecurePaymentArtifact{
            conversation_id: resp["conversationId"],
            page_body: Base.decode64!(resp["threeDSHtmlContent"])}

        metadata =
          %Metadata{
            system_time: resp["systemTime"],
            succeed?: resp["status"] == "success",
            phase: resp["phase"],
            locale: resp["locale"],
            auth_code: resp["authCode"]}

        {:ok, secure_payment_artifact, metadata}
      any ->
        any
     end
  end

  @doc """
  Finalizes a valid secure payment artifact on the remote API.

  ## Options

  See common options.
  """
  @spec finalize_secure_payment_req(Iyzico.SecurePaymentHandle.t, Keyword.t) ::
  {:ok, Iyzico.Payment.t, Iyzico.Metadata.t} |
  {:error, atom}
  def finalize_secure_payment_req(handle = %Iyzico.SecurePaymentHandle{}, opts \\ []) do
    case request([], :post, url_for_path("/payment/3dsecure/auth"), [], handle, opts) do
      {:ok, resp} ->
        if resp["status"] == "success",
          do: serialize_resp(resp),
          else: handle_error(resp)
      any ->
        any
    end
  end

  @doc """
  Revokes an existing payment on the remote API.
  Returns `{:error, :unowned}` if payment is not owned by the API user.

  ## Options

  See common options.
  """
  @spec revoke_payment(binary, binary, Keyword.t) ::
    {:ok, Iyzico.Metadata.t} |
    {:error, :unowned}
  def revoke_payment(payment_id, conversation_id, opts \\ [])
    when is_binary(payment_id) and is_binary(conversation_id) do
    revoke = %RevokePaymentRequest{
      conversation_id: conversation_id,
      payment_id: payment_id,
      ip: @server_ip
    }

    case request([], :post, url_for_path("/payment/cancel"), [], revoke, opts) do
      {:ok, resp} ->
        if resp["status"] == "success" do
          metadata =
            %Metadata{
              system_time: resp["systemTime"],
              succeed?: resp["status"] == "success",
              phase: resp["phase"],
              locale: resp["locale"],
              auth_code: resp["authCode"]}

          {:ok, metadata}
        else
          handle_error(resp)
        end
      any ->
        any
    end
  end

  @doc """
  Same as `revoke_payment/3`, but raises `Iyzico.InternalInconsistencyError` if
  there was an error.
  """
  @spec revoke_payment!(binary, binary, Keyword.t) ::
    Iyzico.Metadata.t |
    no_return
  def revoke_payment!(payment_id, conversation_id, opts \\ []) do
    case revoke_payment(payment_id, conversation_id, opts) do
      {:ok, metadata} ->
        metadata
      {:error, code} ->
        raise Iyzico.InternalInconsistencyError, code: code
    end
  end


  @doc """
  Refunds a payment of a successful transaction by given amount.

  ## Options

  See common options.
  """
  @spec refund_payment(binary, binary, binary, currency, Keyword.t) ::
    {:ok, Iyzico.Metadata.t} |
    {:error, :excessive_funds} |
    {:error, :unowned}
  def refund_payment(transaction_id, conversation_id, price, currency, opts \\ [])
    when is_binary(transaction_id) and is_binary(conversation_id) and
         is_binary(price) do
    refund =
      %RefundPaymentRequest{
        conversation_id: conversation_id,
        transaction_id: transaction_id,
        price: price,
        ip: @server_ip,
        currency: currency
      }

    case request([], :post, url_for_path("/payment/refund"), [], refund, opts) do
      {:ok, resp} ->
        if resp["status"] == "success" do
          metadata =
            %Metadata{
              system_time: resp["systemTime"],
              succeed?: resp["status"] == "success",
              phase: resp["phase"],
              locale: resp["locale"],
              auth_code: resp["authCode"]}

          {:ok, metadata}
        else
          handle_error(resp)
        end
      any ->
        any
    end
  end

  @doc """
  Same as `refund_payment/5`, but raises `Iyzico.InternalInconsistencyError` if
  there was an error.
  """
  @spec refund_payment!(binary, binary, binary, currency, Keyword.t) ::
    Iyzico.Metadata.t |
    no_return
  def refund_payment!(transaction_id, conversation_id, price, currency, opts \\ []) do
    case refund_payment(transaction_id, conversation_id, price, currency, opts) do
      {:ok, metadata} ->
        metadata
      {:error, code} ->
        raise Iyzico.InternalInconsistencyError, code: code
    end
  end

  defp serialize_resp(resp) do
    transactions =
      resp["itemTransactions"]
      |> Enum.map(fn x ->
        %Transaction{
          blockage_rate: x["blockageRate"],
          merchant_blockage_amount: x["blockageRateAmountMerchant"],
          submerchant_blockage_amount: x["blockageRateAmountSubMerchant"],
          resolution_date: x["blockageResolvedDate"],
          converted_payout: %ConvertedPayout{
            merchant_blockage_amount: x["convertedPayout"]["blockageRateAmountMerchant"],
            submerchant_blockage_amount: x["convertedPayout"]["blockageRateAmountSubMerchant"],
            currency: x["convertedPayout"]["currency"],
            commission_fee: x["convertedPayout"]["iyziCommissionFee"],
            commission_amount: x["convertedPayout"]["iyziCommissionRateAmount"],
            conversion_rate: x["convertedPayout"]["iyziConversionRate"],
            conversion_cost: x["convertedPayout"]["iyziConversionRateAmount"],
            merchant_payout_amount: x["convertedPayout"]["merchantPayoutAmount"],
            paid_price: x["convertedPayout"]["paidPrice"],
            submerchant_payout_amount: x["convertedPayout"]["subMerchantPayoutAmount"]
          },
          item_id: x["itemId"],
          commission_amount: x["iyziCommissionRateAmount"],
          commission_fee: x["iyziCommissionFee"],
          merchant_commission_rate: x["merchantCommissionRate"],
          merchant_commission_amount: x["merchantCommissionRateAmount"],
          merchant_payout_amount: x["merchantPayoutAmount"],
          paid_price: x["paidPrice"],
          id: x["paymentTransactionId"],
          price: x["price"],
          submerchant_payout_amount: x["subMerchantPayoutAmount"],
          submerchant_payout_rate: x["subMerchantPayoutRate"],
          submerchant_price: x["subMerchantPrice"],
          transaction_status: Transaction.to_transaction_status(x["transactionStatus"])}
        end)

    payment =
      %Payment{
        basket_id: resp["basketId"],
        bin_id: resp["binNumber"],
        card_ref: %CardReference{
          assoc: Card.get_card_assoc(resp["cardAssociation"]),
          family: Card.get_card_family(resp["cardFamily"]),
          type: Card.get_card_type(resp["cardType"]),
          user_key: resp["cardUserKey"],
          token: resp["cardToken"],
        },
        conversation_id: resp["conversationId"],
        currency: resp["currency"] |> String.downcase() |> String.to_atom(),
        fraud_status: Payment.to_fraud_status(resp["fraudStatus"]),
        installment: resp["installment"],
        transactions: transactions,
        commission_fee: resp["iyziCommissionFee"],
        commission_amount: resp["iyziCommissionRateAmount"],
        last_four_digits: resp["lastFourDigits"],
        merchant_commission_rate: resp["merchantCommissionRate"],
        merchant_commission_amount: resp["merchantCommissionRateAmount"],
        paid_price: resp["paidPrice"],
        price: resp["price"],
        id: resp["paymentId"]}

    metadata =
      %Metadata{
        system_time: resp["systemTime"],
        succeed?: resp["status"] == "success",
        phase: resp["phase"],
        locale: resp["locale"],
        auth_code: resp["authCode"]}

    {:ok, payment, metadata}
  end
end
