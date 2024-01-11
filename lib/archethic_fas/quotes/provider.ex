defmodule ArchethicFAS.Quotes.Provider do
  @moduledoc false

  alias ArchethicFAS.Quotes.UCID

  @callback fetch_latest(list(UCID.t())) ::
              {:ok, %{UCID.t() => float()}} | {:error, String.t()}
end
