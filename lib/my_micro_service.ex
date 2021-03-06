defmodule MyMicroService do
  use Application




  def start(_type, _args) do

    #mix amnesia.drop -d Database --schema
    #mix amnesia.create -d Database --disk


    IO.puts "" 
    :mnesia.stop
    :mnesia.create_schema([node()])
    IO.puts "-->" <> "Starting Mnesia"
    :mnesia.start()
    IO.puts "-->" <> "server started, listening to port : 4000"


    #Emergincy git push
    #
    #$ git add .
    #$ git commit -m "Bug Fixed"
    #$ git push -u origin master



    # - The project contains a poor git commit history (all assignment in mostly 1 commit)
    # - It lacks of test coverage
    #   $ mix test --cover
    # - Naming conventions are hard to track and irrelevant in many places
    #
    # - Some code seems to come from other projects in some files?

    
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
