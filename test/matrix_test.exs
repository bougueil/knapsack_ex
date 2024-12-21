defmodule MatrixTest do
  use ExUnit.Case,
    parameterize:
      for(
        mx <- [MatrixListTuple, MatrixMapTuple, MatrixMapTupleTensor, MatrixMapBinary, Matrix.Nx],
        do: %{mx: mx}
      )

  doctest Knapsack

  test "Matrix replace at", %{mx: mx} do
    assert MatrixHelperTest.replace_at(mx)
  end
end
