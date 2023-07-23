defmodule Behavior.Matrix do
  @type matrix :: any()

  @moduledoc """
  callbacks definitions for Behavior.Matrix


  """

  @doc """
  returns updated mat with mat[i1,j1] = mat[i0,j0]
  """
  @callback replace_at(
              mat :: matrix(),
              i1 :: integer(),
              j1 :: integer(),
              i0 :: integer(),
              j0 :: integer()
            ) :: matrix()

  @doc """
  returns mat with mat[i,j] = val
  """
  @callback replace_at(mat :: matrix(), i :: integer(), j :: integer(), val :: integer()) ::
              matrix()

  @doc """
  returns mat[i,j]
  """
  @callback nth(mat :: matrix(), i :: integer(), j :: integer()) :: integer()

  @doc """
  returns mat[i1,j1] == mat[i0,j0]
  """
  @callback equal_at(
              mat :: matrix(),
              i1 :: integer(),
              j1 :: integer(),
              i0 :: integer(),
              j0 :: integer()
            ) :: boolean()

  @doc """
   returns a new matrix() with all elements equalling val
  """
  @callback matrix_from_duplicate_value(val :: integer(), sz_i :: integer(), sz_j :: integer()) ::
              matrix()

  @doc """
  returns {sz_i, sz_j} 
  """
  @callback info(mat :: matrix()) :: any()
end
