defmodule MyMicroService.Router do

  use Plug.Router

  alias MyMicroService.API

  plug :match

  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Poison

  plug :dispatch

  

  #this wil cause a redirect
  #
  get "/code/get/:code" do
    if MyMicroService.valid_match?(code) ==true do
      API.GetEndPoint.get(conn,code)
    else
      send_resp(conn, 422, "invalid shortcode !")
    end
  end

  #wil return statistics of given shortcode
  #
  get "/code/stats/:code" do
    if MyMicroService.valid_match?(code) ==true do
      API.GetEndPoint.stats(conn,code)
    else
      send_resp(conn, 422, "invalid shortcode !")
    end
  end


  #will bind the given shortcode to the url
  #shortcode will be checked for validity
  #
  post "/code/set" do
    API.PostEndPiont.set(conn)
  end


  #for anything else
  #
  match _ do
    send_resp(conn, 404, "nothing to see hier !")
  end

end
