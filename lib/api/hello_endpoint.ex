defmodule MyMicroService.API.HelloEndpoint do
  import Plug.Conn


  def show(conn,id) do
    grid = MyMicroService.construct(id);
    send_resp(conn, 200, grid)
  end



end
