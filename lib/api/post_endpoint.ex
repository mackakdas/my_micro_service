defmodule MyMicroService.API.PostEndPiont do
  import Plug.Conn




 def set(conn) do

    url =
      case conn.body_params do
        %{"url" => a_name} -> a_name
        _ -> ""
      end

    #get shortcode from json construct
    #
    shortcode =
      case conn.body_params do
        %{"short" => a_name } -> a_name
        _ -> ""
      end

    #if the shortcode comes up empty, create one of 6 chars long
    #
    shortcode =
      case shortcode do
        "" -> MyGlobals.string_of_length(6) 
        _ -> shortcode
      end

    if MyGlobals.valid_match(shortcode) == true do
    
      records = Accounts.get_short_by_name(shortcode)
      
      if records !=[] do
      
        [%Database.Account{stats_value: stats_value, url_value: url_value, id: id, short_value: shortcode, start_date: start_date, lastseen_date: lastseen_date} | _rest] = records
        response = %{"startDate" => start_date, "lastSeenDate" => lastseen_date , "redirectCount" => stats_value , "status" => "known" , "redirectUrl" => url_value ,"shortcode" => shortcode }
        send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))
      
      else
        
        d = DateTime.utc_now
        s = "#{d.year}-#{d.month}-#{d.day} #{d.hour} #{d.minute} #{d.second}"
        Accounts.create_account(url, shortcode, 0, s, s)

        response = %{"startDate" => s, "lastSeenDate" => s, "redirectCount" => "1" , "status" => "ok" , "redirectUrl" => url , "short" => shortcode}
        send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))

      end
    else

      response = %{"startDate" => "", "lastSeenDate" => "" , "redirectCount" => "" , "status" => "invalid shortcode" , "redirectUrl" => "" ,"shortcode" => "" }
      send_resp(conn |> put_resp_content_type("application/json"), 200, Poison.encode!(response))

    end

  end

end
