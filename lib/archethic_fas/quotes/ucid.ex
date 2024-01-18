defmodule ArchethicFAS.Quotes.UCID do
  @moduledoc false

  @type t :: pos_integer()

  @doc """
  Return all handled ucids
  """
  @spec list() :: list(t())
  def list() do
    Application.fetch_env!(:archethic_fas, :ucids)
  end
end
