defmodule KnapsackTest do
  use ExUnit.Case
  doctest Knapsack

  test "MatrixListTuple" do
    assert Knapsack.run(MatrixListTuple) == true
  end

  test "MatrixMapTuple" do
    assert Knapsack.run(MatrixMapTuple) == true
  end

  test "MatrixMapTupleTensor" do
    assert Knapsack.run(MatrixMapTupleTensor) == true
  end

  test "MatrixMapBinary" do
    assert Knapsack.run(MatrixMapBinary) == true
  end

  test "Matrix.Nx" do
    assert Knapsack.run(Matrix.Nx) == true
  end
end
