defmodule Knapsack do
  require Logger

  @moduledoc """

  Documentation for `Knapsack`.

  Elixir adaptation of https://rosettacode.org/wiki/Knapsack_problem/Bounded#Dynamic_programming_solution_2
  """

  # iter over the w columns
  defp iter_weight(table, _mx, _j, _wt, _val, maxwt, maxwt), do: table

  defp iter_weight(table, mx, j, wt, val, w, maxwt) do
    if wt > w do
      mx.replace_at(table, w, j, w, j - 1)
    else
      e1 = mx.nth(table, w, j - 1)
      e2 = mx.nth(table, w - wt, j - 1)
      mx.replace_at(table, w, j, max(e1, e2 + val))
    end
    |> iter_weight(mx, j, wt, val, w + 1, maxwt)
  end

  # iter over the items (j or rows)
  defp iter_item(table, _items, _maxwt, nitems, nitems, _mx), do: table

  defp iter_item(table, items, maxwt, j, nitems, mx) do
    {_item, wt, val} = MatrixListTuple.row_at(items, j - 1)

    iter_weight(table, mx, j, wt, val, 1, maxwt + 1)
    |> iter_item(items, maxwt, j + 1, nitems, mx)
  end

  defp iter_item_add(bag, _table, _items, _i, 0, _mx), do: bag

  defp iter_item_add(bag, table, items, i, j, mx) do
    not_added = mx.equal_at(table, i, j, i, j - 1)

    if not_added do
      # IO.inspect {:row___, j-1, mx.nth(table, i,j), mx.nth(table, i, j-1)}
      iter_item_add(bag, table, items, i, j - 1, mx)
    else
      # IO.inspect {:row_add, j-1, mx.nth(table, i,j), mx.nth(table, i, j-1)}

      tuple = {_item, wt, _val} = MatrixListTuple.row_at(items, j - 1)

      MatrixListTuple.add_row_end(bag, tuple)
      |> iter_item_add(table, items, i - wt, j - 1, mx)
    end
  end

  #  runs the knapsack algorithm with items and mx implementation
  defp knapsack01_dp(items, maxwt, mx) do
    nitems = length(items)

    table =
      mx.matrix_from_duplicate_value(0, maxwt + 1, nitems + 1)
      |> iter_item(items, maxwt, 1, nitems + 1, mx)

    bag = []
    sz_i = maxwt
    iter_item_add(bag, table, items, sz_i, nitems, mx)
  end

  @doc """
  runs the knapsack algo with an mx implementation

  internally calls knapsack01_dp with some predefined items
  """
  @spec run(mx :: term()) :: true | false
  def run(mx) do
    # maxwt = 15
    # maxwt = 400
    maxwt = 500

    groupeditems = [
      # item 	weight (dag) (each) 	value (each) 	piece(s) 
      {"map", 9, 150, 1},
      {"compass", 13, 35, 1},
      {"water", 153, 200, 3},
      {"sandwich", 50, 60, 2},
      {"glucose", 15, 60, 2},
      {"tin", 68, 45, 3},
      {"banana", 27, 60, 3},
      {"apple", 39, 40, 3},
      {"cheese", 23, 30, 1},
      {"beer", 52, 10, 3},
      {"suntan cream", 11, 70, 1},
      {"camera", 32, 30, 1},
      {"t-shirt", 24, 15, 2},
      {"trousers", 48, 10, 2},
      {"umbrella", 73, 40, 1},
      {"waterproof trousers", 42, 70, 1},
      {"waterproof overclothes", 43, 75, 1},
      {"note-case", 22, 80, 1},
      {"sunglasses", 7, 20, 1},
      {"towel", 18, 12, 2},
      {"socks", 4, 50, 1},
      {"book", 30, 10, 2}
    ]

    expected = [
      [num_item: 3, off: "banana"],
      [num_item: 1, off: "cheese"],
      [num_item: 1, off: "compass"],
      [num_item: 2, off: "glucose"],
      [num_item: 1, off: "map"],
      [num_item: 1, off: "note-case"],
      [num_item: 1, off: "sandwich"],
      [num_item: 1, off: "socks"],
      [num_item: 1, off: "sunglasses"],
      [num_item: 1, off: "suntan cream"],
      [num_item: 1, off: "water"],
      [num_item: 1, off: "waterproof overclothes"],
      [num_item: 1, off: "waterproof trousers"]
    ]

    items =
      for(
        {item, wt, val, num} <- groupeditems,
        do: List.duplicate({item, wt, val}, num)
      )
      |> List.flatten()

    :erlang.garbage_collect()
    t0 = System.system_time(:microsecond)

    bagged = knapsack01_dp(items, maxwt, mx)

    elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    Logger.info("#{inspect(mx)} knapsack with #{length(bagged)} items in #{elapsed_ms} ms.")

    bagged =
      Enum.group_by(bagged, & &1)
      |> Enum.map(fn {x, y} -> {x, length(y)} end)
      |> Enum.map(fn {{name, _wt, _val}, num_item} -> [num_item: num_item, off: name] end)

    Logger.debug("#{inspect(bagged, pretty: true)}")
    expected == bagged
  end
end
