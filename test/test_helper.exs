ExUnit.start()
require Logger

defmodule MatrixHelperTest do
  def replace_at(mx) do
    len = 600
    lm1 = len - 1

    op = "assign [i][n] = i"
    mat = mx.matrix_from_duplicate_value(0, len, len)

    {elapsed_ms, mat} =
      :timer.tc(fn ->
        Enum.reduce(0..(len - 1), mat, fn pos, m ->
          mx.replace_at(m, pos, len - 1, pos)
        end)
      end)

    elapsed_ms = div(elapsed_ms, 1000)

    v1 = match?(^lm1, mx.nth(mat, len - 1, len - 1))
    Logger.info("#{mx} #{op} in #{elapsed_ms} ms.")

    op = "assign [i][i] = [i+1][i+1]"

    {elapsed_ms, mat} =
      :timer.tc(fn ->
        Enum.reduce((len - 1)..1//-1, mat, fn pos, m ->
          mx.replace_at(m, pos - 1, pos - 1, pos, pos)
        end)
      end)

    elapsed_ms = div(elapsed_ms, 1000)

    v2 = match?(^lm1, mx.nth(mat, 0, 0))
    Logger.info("#{mx} #{op} in #{elapsed_ms} ms.")

    op = "[i][i-1] = [i][i]"

    {elapsed_ms, mat} =
      :timer.tc(fn ->
        Enum.reduce((len - 1)..1//-1, mat, fn pos, m ->
          mx.replace_at(m, pos, pos - 1, pos, pos)
        end)
      end)

    elapsed_ms = div(elapsed_ms, 1000)

    v3 = match?(^lm1, mx.nth(mat, 1, 0))
    Logger.info("#{mx} #{op} in #{elapsed_ms} ms.")

    op = "assign [i-1][i] = [i][i]"

    {elapsed_ms, mat} =
      :timer.tc(fn ->
        Enum.reduce((len - 1)..1//-1, mat, fn pos, m ->
          mx.replace_at(m, pos - 1, pos, pos, pos)
        end)
      end)

    elapsed_ms = div(elapsed_ms, 1000)
    v4 = match?(^lm1, mx.nth(mat, 0, 1))
    Logger.info("#{mx} #{op} in #{elapsed_ms} ms.")

    op = "[i-1][i] = [i][i]"

    {elapsed_ms, _mat} =
      :timer.tc(fn ->
        Enum.reduce((len - 1)..1//-1, mat, fn pos, m ->
          e1 = mx.nth(m, pos, pos - 1)
          e2 = mx.nth(m, pos - 1, pos)

          mx.replace_at(m, pos - 1, pos - 1, max(e1, e2))
        end)
      end)

    elapsed_ms = div(elapsed_ms, 1000)
    Logger.info("#{mx} #{op} in #{elapsed_ms} ms.")
    Enum.all?([v1, v2, v3, v4])
  end
end
