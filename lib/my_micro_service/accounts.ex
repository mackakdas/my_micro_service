defmodule Accounts do
  require Amnesia
  require Amnesia.Helper
  require Exquisite
  require Database.Account

  alias Database.Account

  def create_account(url_value, short_value, stats_value, start_date, lastseen_date) do
    Amnesia.transaction do
      %Account{url_value: url_value, short_value: short_value, stats_value: stats_value, start_date: start_date, lastseen_date: lastseen_date}
      |> Account.write()
    end
  end

  def get_account(account_id) do
    Amnesia.transaction do
      Account.read(account_id)
    end
    |> case do
      %Account{} = account -> account
      _ -> {:error, :not_found}
    end
  end




  def get_short_by_name(short_name) do
    Amnesia.transaction do
      Account.where(short_value == short_name)
      |> Amnesia.Selection.values()
    end
  end

  def set_stats_value(account_id, value,lastseen_date) do
    Amnesia.transaction do
      case Account.read(account_id) do
        %Account{} = account ->
            adjust_account_stats(account, value,lastseen_date)
        _ ->
          {:error, :not_found}
      end
    end


  end



  defp adjust_account_stats(%Account{} = account, value, lastseen_date) do
    value = value + 1
    account
    |> Map.merge(%{stats_value: value , lastseen_date:  lastseen_date} )
    |> Account.write()

  end







end
