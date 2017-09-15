defmodule Iyzico.BinInquiryTest do
  use Iyzico.EndpointCase

  import Iyzico.BinInquiry

  test "inquiries a bin number" do
    {:ok, inquiry, metadata} = perform_inquiry("554960", "123456789", "100.0", :try)

    assert inquiry
    assert metadata.succeed?
  end

  test "local cards could not perform transactions with foreign currencies" do
    {:error, code} = perform_inquiry("554960", "123456789", "100.0", :eur)

    assert code == :local_card_on_foreign_cur
  end
end
