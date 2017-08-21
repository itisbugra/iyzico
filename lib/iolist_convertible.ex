defprotocol Iyzico.IOListConvertible do
  @moduledoc """
  Converts a struct to iolist.
  """
  def to_iolist(data)
end
