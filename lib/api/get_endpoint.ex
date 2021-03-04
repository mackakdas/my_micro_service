defmodule MyMicroService.API.GetEndPoint do
  import Plug.Conn

  def get(conn,shortcode) do

	
	#find the record with the shortcode
	#
    records = Accounts.get_short_by_name(shortcode)
   

	if records !=[] do

		#get record's fields
		#
		[%Database.Account{stats_value: stats_value, url_value: url_value, id: id, short_value: _shortcode, start_date: _start_date, lastseen_date: _lastseen_date} | _rest] = records

		d = DateTime.utc_now
		s = "#{d.year}-#{d.month}-#{d.day} #{d.hour} #{d.minute} #{d.second}"

		#change stats field and date_requested field
		#
		Accounts.set_stats_value(id,stats_value ,s)


		#response = %{"startDate" => start_date, "lastSeenDate" => lastseen_date , "redirectCount" => stats_value}
		#send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))

		#build a redirection HTML content
		#
		redirect ='<html><head><title>HTML Meta Tag</title><meta http-equiv = "refresh" content = "0; url = https://#{url_value}" /></head><body></body></html>'
		send_resp(conn |> put_resp_content_type("text/html"), 302, redirect)

	else
		send_resp(conn |> put_resp_content_type("text/html"), 401, "nothing")
	end
  end



  def stats(conn,shortcode) do

	#find the record with the shortcode
	#
    records = Accounts.get_short_by_name(shortcode)
	if records !=[] do


		#get record's fields
		#
		[%Database.Account{stats_value: stats_value, url_value: url_value, id: id, short_value: _shortcode, start_date: start_date, lastseen_date: lastseen_date} | _rest] = records

		#create a json construct
		#
		response = %{"startDate" => start_date, "lastSeenDate" => lastseen_date , "redirectCount" => stats_value , "status" => "ok" , "redirectUrl" => url_value}
		send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))
	else

		#create a json construct
		#when not found, we retain the returned json structure
		#
		response = %{"startDate" => "", "lastSeenDate" => "" , "redirectCount" => "" , "status" => "notfound" , "redirectUrl" => "" , "short" => ""}
		send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))

	end
  end
end
