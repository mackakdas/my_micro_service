defmodule MyMicroService do
  use Application
  use ExUnit.Case

  def start(_type, _args) do


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


  def post_body() do
    %{"url" => "www.bbc.com",
    "short" => "bbcnews"
    } |> Poison.encode!
  end


  test "API code post " do

      resp = HTTPoison.post!("http://localhost:4000/code/set", post_body(), %{"Content-Type" => "application/json", "Cache-Control" => "no-cache"})
      #IO.puts inspect resp
      assert resp.status_code == 200
  end


  test "API code get " do

      resp = HTTPoison.get!("http://localhost:4000/code/get/bbcnews")
      #IO.puts inspect resp
      assert resp.status_code == 302
  end


  test "API code stats " do

      resp = HTTPoison.get!("http://localhost:4000/code/stats/bbcnews")
      #IO.puts inspect resp
      assert resp.status_code == 200
  end


end
