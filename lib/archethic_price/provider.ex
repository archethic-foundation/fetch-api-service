defmodule ArchethicPrice.Provider do
  @moduledoc false

  @callback get_current(list(ArchethicPrice.currency())) ::
              {:ok,
               %{
                 ArchethicPrice.currency() => float()
               }}
              | {:error, atom()}
end
