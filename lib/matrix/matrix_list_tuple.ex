defmodule MatrixListTuple do
  @behaviour Behavior.Matrix

  @moduledoc """

    zero-based 16bits integer matrix 

    mat[i][j] is an integer from the ith column
      a 3x2 matrix with val 511 everywhere is represented as:
      [{511, 511, 511},
      {511, 511, 511}]

  python is reverse [i][j] becomes [j][i]
  """
  alias Behavior.Matrix

  @type matrix :: any()
  @compile {:inline, nth: 3, row_at: 2}

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i1, j, i0, j) do
    row = row_at(mat, j)
    elem0 = elem(row, i0)
    row = put_elem(row, i1, elem0)
    List.replace_at(mat, j, row)
  end

  # mat[i1,j1] <- mat[i0,j0]
  def replace_at(mat, i1, j1, i0, j0) do
    elem = nth(mat, i0, j0)
    replace_at(mat, i1, j1, elem)
  end

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i, j, val) do
    tuple = row_at(mat, j) |> put_elem(i, val)
    List.replace_at(mat, j, tuple)
  end

  @impl Matrix
  @spec equal_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: boolean()
  def equal_at(mat, i1, j1, i0, j0) do
    nth(mat, i1, j1) == nth(mat, i0, j0)
  end

  @impl Matrix
  @spec nth(Matrix.matrix(), integer(), integer()) :: integer()
  def nth(mat, i, j) do
    row_at(mat, j) |> elem(i)
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
    {tuple_size(hd(mat)), length(mat)}
  end

  @spec row_at(Matrix.matrix(), integer()) :: tuple()
  def row_at(mat, j) when is_list(mat) do
    :lists.nth(j + 1, mat)
  end

  @spec add_row_end(Matrix.matrix(), tuple()) :: Matrix.matrix()
  def add_row_end(mat, row) when is_tuple(row) do
    :lists.append(mat, [row])
  end

  def make_row(val, size) do
    Tuple.duplicate(val, size)
  end

  def matrix_from_duplicate_row(row, size) when is_tuple(row) do
    List.duplicate(row, size)
  end
end
