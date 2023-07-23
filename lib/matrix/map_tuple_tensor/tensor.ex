defmodule MapTupleAccessTensor do
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

defmodule MapTupleAccessColumn do
  defstruct [:col]

  @moduledoc """
  2nd level that implement row access (from columns)
  """

  ## Access

  @behaviour Access

  @impl true
  def fetch(col, index) do
    {:ok, elem(col.col, index)}
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
