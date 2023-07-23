defmodule Matrix.Nx do
  @behaviour Behavior.Matrix

  alias Behavior.Matrix

  @type matrix :: any()

  @moduledoc """
    mat[i][j] is an integer from the ith column
    a 3x2 matrix with val 511 everywhere is represented as:

    #Nx.Tensor<
      s16[3][2]
      [
        [511, 511],
        [511, 511],
        [511, 511]
      ]

    keys are columns (i) pointing to a tuple
    j are index in the tuple
  """

  @compile {:inline, nth: 3}

  # mat[i1,j1] <- mat[i0,j0]
  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i1, j1, i0, j0) do
    val = nth(mat, i0, j0)
    replace_at(mat, i1, j1, val)
  end

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(mat, i, j, val) when is_integer(val) do
    Nx.put_slice(mat, [i, j], Nx.tensor([[val]]))
  end

  @impl Matrix
  @spec equal_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: boolean()
  def equal_at(mat, i1, j1, i0, j0) do
    nth(mat, i1, j1) == nth(mat, i0, j0)
  end

  @impl Matrix
  @spec nth(Matrix.matrix(), integer(), integer()) :: integer()
  def nth(mat, i, j) do
    Nx.to_number(mat[i][j])
  end

  @impl Matrix
  @spec matrix_from_duplicate_value(integer(), integer(), integer()) :: Matrix.matrix()
  def matrix_from_duplicate_value(val, sz_i, sz_j) do
    Nx.tensor(List.duplicate(List.duplicate(val, sz_j), sz_i), type: {:s, 16})
  end

  @impl Matrix
  @spec info(matrix()) :: any()
  def info(mat) do
    Nx.shape(mat)
  end

  def quick(), do: Nx.tensor(List.duplicate(List.duplicate(0, 3), 2), type: {:s, 16})
end
