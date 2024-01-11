defmodule ArchethicFAS.Quotes.UCID do
  @moduledoc false

  @ucids Application.compile_env!(:archethic_fas, :ucids)

  @type t :: pos_integer()

  @doc """
  Return all handled ucids
  """
  @spec list() :: list(t())
  def list() do
    @ucids
  end
end
