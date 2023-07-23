# https://github.com/codedge-llc/accessible/tree/master/lib
# https://github.com/mbramson/struct_access/blob/master/lib/struct_access.ex

defmodule MatrixMapTuple do
  @behaviour Behavior.Matrix

  @moduledoc """
    mat[i][j] is an integer from the ith column
    a 3x2 matrix with val 511 everywhere is represented as:

    %{0 => {511, 511, 511}, 
      1 => {511, 511, 511}}

    keys are columns (i) pointing to a tuple
    j are index in the tuple
  """

  alias Behavior.Matrix

  @compile {:inline, nth: 3}

  @type matrix :: map()

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i1, j, i0, j) do
    row = mat[j]
    %{mat | j => put_elem(row, i1, elem(row, i0))}
  end

  # mat[i1,j1] <- mat[i0,j0]
  def replace_at(mat, i1, j1, i0, j0) do
    elem = nth(mat, i0, j0)
    replace_at(mat, i1, j1, elem)
  end

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i, j, val) do
    %{mat | j => put_elem(mat[j], i, val)}
  end

  @impl Matrix
  @spec equal_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: boolean()
  def equal_at(mat, i1, j1, i0, j0) do
    nth(mat, i1, j1) == nth(mat, i0, j0)
  end

  @impl Matrix
  @spec nth(Matrix.matrix(), integer(), integer()) :: integer()
  def nth(mat, i, j) do
    elem(mat[j], i)
  end

  @impl Matrix
  @spec matrix_from_duplicate_value(integer(), integer(), integer()) :: Matrix.matrix()
  def matrix_from_duplicate_value(val, sz_i, sz_j) do
    make_row(val, sz_i)
    |> matrix_from_duplicate_row(sz_j)
  end

  @impl Matrix
  @spec info(matrix()) :: any()
  def info(mat) do
    {tuple_size(mat[0]), map_size(mat)}
  end

  @spec row_at(Matrix.matrix(), integer()) :: tuple()
  def row_at(mat, j) when is_map(mat) do
    mat[j]
  end

  @spec add_row_end(Matrix.matrix(), tuple()) :: Matrix.matrix()
  def add_row_end(mat, row) when is_tuple(row) do
    sz = map_size(mat)
    Map.put(mat, sz, row)
  end

  def make_row(val, size) do
    Tuple.duplicate(val, size)
  end

  def matrix_from_duplicate_row(row, size) when is_tuple(row) do
    Enum.reduce(0..(size - 1), %{}, fn j, mat -> Map.put(mat, j, row) end)
  end
end
