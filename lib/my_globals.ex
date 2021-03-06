
defmodule MyGlobals do
def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end



  def valid_match(code) do
    String.match?(code, ~r/^[0-9a-zA-Z_]{4,}$/)
  end  

  def string_of_length(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end
end
