
defmodule MyGlobals do

    #check code for validity against regex pattern
    #
    def valid_match(code) do
      String.match?(code, ~r/^[0-9a-zA-Z_]{4,}$/)
    end  

    #get a string of length filled with random chars
    #
    def string_of_length(length) do
      Enum.reduce((1..length), [], fn (_i, acc) ->
        [Enum.random("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" |> String.split("")) | acc]
      end) |> Enum.join("")
    end
end
