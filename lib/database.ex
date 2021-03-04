use Amnesia

defdatabase Database do
  deftable(
    Account,
    [{:id, autoincrement}, :short_value, :url_value, :stats_value, :start_date, :lastseen_date],
    type: :ordered_set,
    index: [:short_value]
  )



end
