defmodule ArchethicFAS.QuotesHistorical.Interval do
  @type t ::
          :hourly
          | :daily
          | :weekly
          | :biweekly
          | :monthly
          | :bimonthly
          | :yearly
  # :all

  @doc """
  Parse a string into an interval
  """
  @spec parse(String.t()) :: {:ok, t()} | :error
  def parse("hourly"), do: {:ok, :hourly}
  def parse("daily"), do: {:ok, :daily}
  def parse("weekly"), do: {:ok, :weekly}
  def parse("biweekly"), do: {:ok, :biweekly}
  def parse("monthly"), do: {:ok, :monthly}
  def parse("bimonthly"), do: {:ok, :bimonthly}
  def parse("yearly"), do: {:ok, :yearly}
  # def parse("all"), do: {:ok, :all}
  def parse(_), do: :error

  @doc """
  List the available intervals
  """
  @spec list() :: list(t())
  def list,
    do: [
      :hourly,
      :daily,
      :weekly,
      :biweekly,
      :monthly,
      :bimonthly,
      :yearly
      # :all
    ]

  @doc """
  Returns the datetime from a interval
  """
  @spec get_datetime(t()) :: DateTime.t()
  def get_datetime(:hourly) do
    minus_hour = DateTime.add(DateTime.utc_now(), -3600)
    date = DateTime.to_date(minus_hour)
    time = DateTime.to_time(minus_hour)

    {:ok, datetime, _} =
      DateTime.from_iso8601(
        "#{Date.to_iso8601(date)} #{%Time{hour: time.hour, minute: 0, second: 0} |> Time.to_iso8601()}Z"
      )

    datetime
  end

  def get_datetime(:daily) do
    datetime_reset_hours(DateTime.utc_now())
  end

  def get_datetime(:weekly) do
    datetime_reset_hours(DateTime.add(DateTime.utc_now(), -86400 * 7))
  end

  def get_datetime(:biweekly) do
    datetime_reset_hours(DateTime.add(DateTime.utc_now(), -86400 * 14))
  end

  def get_datetime(:monthly) do
    datetime_reset_hours(DateTime.add(DateTime.utc_now(), -86400 * 30))
  end

  def get_datetime(:bimonthly) do
    datetime_reset_hours(DateTime.add(DateTime.utc_now(), -86400 * 60))
  end

  def get_datetime(:yearly) do
    datetime_reset_hours(DateTime.add(DateTime.utc_now(), -86400 * 365))
  end

  # def get_datetime(:all) do
  #   DateTime.from_unix!(0)
  # end

  defp datetime_reset_hours(date_from) do
    {:ok, date, _} =
      "#{date_from |> DateTime.to_date() |> Date.to_iso8601()} 00:00:00Z"
      |> DateTime.from_iso8601()

    date
  end
end
