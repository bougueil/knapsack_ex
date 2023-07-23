defmodule MatrixTest do
  use ExUnit.Case
  doctest Knapsack

  test "replace at MatrixListTuple" do
    assert MatrixHelperTest.replace_at(MatrixListTuple) == true
  end

  test "replace at MatrixMapTuple" do
    assert MatrixHelperTest.replace_at(MatrixMapTuple) == true
  end

  test "replace at MatrixMapTupleTensor" do
    assert MatrixHelperTest.replace_at(MatrixMapTupleTensor) == true
  end

  test "replace at MatrixMapBinary" do
    assert MatrixHelperTest.replace_at(MatrixMapBinary) == true
  end

  test "replace at Matrix.Nx" do
    assert MatrixHelperTest.replace_at(Matrix.Nx) == true
  end
end
