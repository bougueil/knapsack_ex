defmodule MatrixMapBinary do
  @moduledoc """

  zero-based s16 matrix,
  works well with big matrix

  mat[i][j] is an integer from the ith column
    a 3x2 matrix with val 511 everywhere is represented as:
    %MapBinTensor{
      cols: %{
        0 => %MapBinColumn{col: <<1, 255, 1, 255>>},
        1 => %MapBinColumn{col: <<1, 255, 1, 255>>},
        2 => %MapBinColumn{col: <<1, 255, 1, 255>>}
      },
      shape: {3, 4}
  }
  """
  @behaviour Behavior.Matrix

  alias Behavior.Matrix

  import Bitwise

  @type matrix :: %MapBinTensor{}

  @compile {:inline, nth: 3}

  # mat[i1,j1] <- mat[i0,j0]
  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(%{cols: cols} = mat, i1, j1, i0, j0) do
    %{
      ^i0 => %MapBinColumn{col: <<_::binary-size(bsl(j0, 1)), val::16, _::binary>>},
      ^i1 => %MapBinColumn{col: <<pa1::binary-size(bsl(j1, 1)), _::16, pb1::binary>>}
    } = cols

    %{
      mat
      | cols:
          Map.put(mat.cols, i1, %MapBinColumn{
            col: <<pa1::binary-size(bsl(j1, 1)), val::16, pb1::binary>>
          })
    }
  end

  @impl Matrix
  @spec replace_at(Matrix.matrix(), integer(), integer(), integer()) :: Matrix.matrix()
  def replace_at(%{cols: cols} = mat, i, j, val) when is_integer(val) do
    %{^i => %MapBinColumn{col: <<pa::binary-size(bsl(j, 1)), _::16, pb::binary>>}} = cols

    %{
      mat
      | cols:
          Map.put(mat.cols, i, %MapBinColumn{
            col: <<pa::binary-size(bsl(j, 1)), val::16, pb::binary>>
          })
    }
  end

  @impl Matrix
  @spec equal_at(Matrix.matrix(), integer(), integer(), integer(), integer()) :: boolean()
  def equal_at(mat, i1, j1, i0, j0) do
    nth(mat, i1, j1) == nth(mat, i0, j0)
  end

  @impl Matrix
  @spec nth(Matrix.matrix(), integer(), integer()) :: integer()
  def nth(%{cols: cols}, i, j) do
    %{^i => %MapBinColumn{col: <<_::binary-size(bsl(j, 1)), val::16, _::binary>>}} = cols
    val
  end

  @impl Matrix
  @spec matrix_from_duplicate_value(integer(), integer(), integer()) :: Matrix.matrix()
  def matrix_from_duplicate_value(val, sz_i, sz_j) do
    make_col(val, sz_j)
    |> matrix_from_duplicate_col(sz_i)
  end

  def matrix_from_duplicate_col(col, size) when is_binary(col) do
    Enum.reduce(
      0..(size - 1),
      %MapBinTensor{shape: {size, byte_size(col)}},
      fn i, mat -> %{mat | cols: Map.put(mat.cols, i, %MapBinColumn{col: col})} end
    )
  end

  @impl Matrix
  @spec info(matrix()) :: any()
  def info(%{cols: cols = %{0 => %MapBinColumn{col: col}}}) do
    {byte_size(col), map_size(cols)}
  end

  def make_col(val, size) do
    :binary.copy(<<val::16>>, size)
  end
end
