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


  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end

  def valid_match?(code) do
    String.match?(code, ~r/^[0-9a-zA-Z_]{4,}$/)
  end



  #this litle feature creates an image from given name
  #use:
  #localhost:4000/code/create/mack
  #
  def create(input) do

    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def construct(input) do

    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
  end


  def save_image(image, input) do
    File.write("#{input}.png", image)
  end


  def draw_image(%MyMicroService.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, :egd.color(color))
    end

    :egd.render(image)
  end

  def build_pixel_map(%MyMicroService.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->

      if(index != nil) do

        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end
    end


    %MyMicroService.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%MyMicroService.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      if(code != nil)do
          rem(code, 2) == 0
        end
    end

    %MyMicroService.Image{image | grid: grid}
  end

  def build_grid(%MyMicroService.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %MyMicroService.Image{image | grid: grid}
  end




  def mirror_row(row) do

    if(length(row) !=1 ) do
      [first, second | _tail] = row
      row ++ [second, first]
    end
  end

  def pick_color(%MyMicroService.Image{hex: [r, g, b | _tail]} = image) do
    %MyMicroService.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %MyMicroService.Image{hex: hex}
  end


end
