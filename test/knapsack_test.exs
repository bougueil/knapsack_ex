defmodule KnapsackTest do
  use ExUnit.Case,
    parameterize:
      for(
        mx <- [MatrixListTuple, MatrixMapTuple, MatrixMapTupleTensor, MatrixMapBinary, Matrix.Nx],
        do: %{mx: mx}
      )

  doctest Knapsack

  test "Knapsack", %{mx: mx} do
    assert Knapsack.run(mx)
  end
end
