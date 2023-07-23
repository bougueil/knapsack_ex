defmodule MapBinTensor do
  @moduledoc """
  first level that implement colums access
  """
  defstruct cols: %{}, shape: nil

  ## Access

  @behaviour Access

  @impl true

  def fetch(tensor, index) when is_integer(index) do
    Map.fetch(tensor.cols, index)
  end

  def fetch(_tensor, value) do
    raise """
    tensor[slice] expects slice to be one of:

    * an integer or a scalar tensor representing a zero-based index
    * a first..last range representing inclusive start-stop indexes
    * a list of integers and ranges
    * a keyword list of integers and ranges

    Got #{inspect(value)}
    """
  end

  @impl true
  def get_and_update(_tensor, _index, _update) do
    raise "Access.get_and_update/3 is not yet supported by Nx.Tensor"
  end

  @impl true
  def pop(_tensor, _index) do
    raise "Access.pop/2 is not yet supported by Nx.Tensor"
  end
end

defmodule MapBinColumn do
  import Bitwise

  @moduledoc """
  2nd level that implement row access (from columns)
  """
  defstruct [:col]

  ## Access

  @behaviour Access

  @impl true
  def fetch(col, index) do
    {:ok, binary_part(col.col, bsl(index, 1), 2)}
  end

  @impl true
  def pop(tensor, index) do
    raise "Access.pop/2 is not yet supported by #{__MODULE__}  #{inspect({tensor, index})}"
  end

  @impl true
  def get_and_update(tensor, index, update) do
    raise "Access.get_and_update/3 is not yet supported by #{__MODULE__}  #{inspect({tensor, index, update})}"
  end
end
