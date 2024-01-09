defmodule ArchethicPrice.Provider do
  @moduledoc false

  alias ArchethicPrice.Currency

  @callback get_current(list(Currency.t())) ::
              {:ok, %{Currency.t() => float()}} | {:error, String.t()}
end
