defmodule ArchethicFAS.Provider do
  @moduledoc false

  alias ArchethicFAS.Currency

  @callback get_current(list(Currency.t())) ::
              {:ok, %{Currency.t() => float()}} | {:error, String.t()}
end
