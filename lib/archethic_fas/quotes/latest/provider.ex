defmodule ArchethicFAS.QuotesLatest.Provider do
  @moduledoc false

  alias ArchethicFAS.UCID

  @callback fetch_latest(list(UCID.t())) ::
              {:ok, %{UCID.t() => float()}} | {:error, String.t()}
end
