defmodule MyMicroService do
  use Application


  @chars "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" |> String.split("")


  def start(_type, _args) do

    #mix amnesia.drop -d Database --schema
    #mix amnesia.create -d Database --disk


    #TODOS: Check for
    #mnesia running
    #ensure_schema_exists
    #ensure_table_exists

    IO.puts "" 
    :mnesia.stop
    :mnesia.create_schema([node()])
    IO.puts "-->" <> "Starting Mnesia"
    :mnesia.start()
    IO.puts "-->" <> "server started, listening to port : 4000"






    
    #TODOS: 
    #configuration file

    children = [
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: MyMicroService.Router,
          options: [port: 4000]
        )
      ]
      opts = [strategy: :one_for_one, name: MyMicroService.Supervisor]
      Supervisor.start_link(children, opts)
 
  end


 




end
