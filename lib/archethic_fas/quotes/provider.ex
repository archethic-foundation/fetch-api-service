defmodule ArchethicFAS.Quotes.Provider do
  @moduledoc false

  alias ArchethicFAS.Quotes.Currency

  @callback fetch_latest(list(Currency.t())) ::
              {:ok, %{Currency.t() => float()}} | {:error, String.t()}
end
