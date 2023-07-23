defmodule MatrixMapTupleTensor do
  @behaviour Behavior.Matrix

  @moduledoc """
    faster than MatrixMapBinary if n x m with n < 5000

      zero-based integer matrix 

    mat[i][j] is an integer from the ith column
      a 3x2 matrix with val 511 everywhere is represented as:
      %MapTupleAccessTensor{
        cols: %{
          0 => %MapTupleAccessColumn{col: {511, 511}},
          1 => %MapTupleAccessColumn{col: {511, 511}},
          2 => %MapTupleAccessColumn{col: {511, 511}}
        },
        shape: {3, 2}
      }

    keys are columns (i) pointing to a tuple
    j are index in the tuple

    https://github.com/codedge-llc/accessible/tree/master/lib
    https://github.com/mbramson/struct_access/blob/master/lib/struct_access.ex
  """

  @compile {:inline, nth: 3, replace_at: 4}
  alias Behavior.Matrix

  @type matrix :: %MapTupleAccessTensor{}

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: Matrix.matrix()
  @doc """
     mat[i1,j1] <- mat[i0,j0]
  """
  def replace_at(%{cols: cols} = mat, i0, j1, i0, j0) do
    %{^i0 => %MapTupleAccessColumn{col: col0}} = cols

    %{
      mat
      | cols:
          Map.put(mat.cols, i0, %MapTupleAccessColumn{col: put_elem(col0, j1, elem(col0, j0))})
    }
  end

  def replace_at(%{cols: cols} = mat, i1, j1, i0, j0) do
    %{^i0 => %MapTupleAccessColumn{col: col0}, ^i1 => %MapTupleAccessColumn{col: col1}} = cols

    %{
      mat
      | cols:
          Map.put(mat.cols, i1, %MapTupleAccessColumn{col: put_elem(col1, j1, elem(col0, j0))})
    }

    # replace_at mat, i1, j1, nth(i0, j0)
  end

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(%{cols: cols} = mat, i, j, val) do
    %{^i => %MapTupleAccessColumn{col: col}} = cols
    %{mat | cols: Map.put(mat.cols, i, %MapTupleAccessColumn{col: put_elem(col, j, val)})}
  end

  @impl Matrix
  @spec equal_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: boolean()
  def equal_at(mat, i1, j1, i0, j0) do
    nth(mat, i1, j1) == nth(mat, i0, j0)
  end

  @impl Matrix
  @spec nth(Matrix.matrix(), integer(), integer()) :: integer()
  def nth(%{cols: cols}, i, j) do
    %{^i => %MapTupleAccessColumn{col: col}} = cols
    elem(col, j)
  end

  @impl Matrix
  @spec matrix_from_duplicate_value(integer(), integer(), integer()) :: Matrix.matrix()
  def matrix_from_duplicate_value(val, sz_i, sz_j) do
    make_col(val, sz_j)
    |> matrix_from_duplicate_col(sz_i)
  end

  @impl Matrix
  @spec info(matrix()) :: any()
  def info(mat) do
    {tuple_size(mat[0].col), map_size(mat.cols)}
  end

  ### PRIVATE

  defp make_col(val, size) do
    Tuple.duplicate(val, size)
  end

  defp matrix_from_duplicate_col(col, size) when is_tuple(col) do
    Enum.reduce(
      0..(size - 1),
      %MapTupleAccessTensor{shape: {size, tuple_size(col)}},
      fn i, mat -> %{mat | cols: Map.put(mat.cols, i, %MapTupleAccessColumn{col: col})} end
    )
  end
end
