defmodule ArchethicFAS.QuotesHistorical.Provider do
  @moduledoc false

  @callback fetch_history(coin :: String.t(), from :: DateTime.t(), to :: DateTime.t()) ::
              {:ok, map()} | {:error, String.t()}
end
