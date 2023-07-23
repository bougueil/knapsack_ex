ExUnit.start()
require Logger

defmodule MatrixHelperTest do
  def replace_at(mx) do
    len = 600
    lm1 = len - 1

    mat =
      mx.matrix_from_duplicate_value(0, len, len)

    # assign [i][n] = i
    t0 = System.system_time(:microsecond)

    mat =
      Enum.reduce(0..(len - 1), mat, fn pos, m ->
        mx.replace_at(m, pos, len - 1, pos)
      end)

    elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    v1 = match?(^lm1, mx.nth(mat, len - 1, len - 1))
    Logger.info("#{inspect(mx)} run [i][n] = i in #{elapsed_ms} ms.")

    # assign [i][i] = [i+1][i+1] 
    t0 = System.system_time(:microsecond)

    mat =
      Enum.reduce((len - 1)..1, mat, fn pos, m ->
        mx.replace_at(m, pos - 1, pos - 1, pos, pos)
      end)

    elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    v2 = match?(^lm1, mx.nth(mat, 0, 0))
    Logger.info("#{inspect(mx)} run [i][i] = [i+1][i+1] in #{elapsed_ms} ms.")

    # assign [i][i-1] = [i][i] 
    t0 = System.system_time(:microsecond)

    mat =
      Enum.reduce((len - 1)..1, mat, fn pos, m ->
        mx.replace_at(m, pos, pos - 1, pos, pos)
      end)

    elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    v3 = match?(^lm1, mx.nth(mat, 1, 0))
    Logger.info("#{inspect(mx)} run [i][i-1] = [i][i] in #{elapsed_ms} ms.")

    # assign [i-1][i] = [i][i] 
    t0 = System.system_time(:microsecond)

    mat =
      Enum.reduce((len - 1)..1, mat, fn pos, m ->
        mx.replace_at(m, pos - 1, pos, pos, pos)
      end)

    elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    v4 = match?(^lm1, mx.nth(mat, 0, 1))
    Logger.info("#{inspect(mx)} run [i-1][i] = [i][i] in #{elapsed_ms} ms.")

    # # assign [i-1][i] = [i][i] 
    # t0 = System.system_time(:microsecond)

    # Enum.reduce((len - 1)..1, mat, fn pos, m ->
    #   e1 = mx.nth(m, pos, pos - 1)
    #   e2 = mx.nth(m, pos - 1, pos)

    #   mx.replace_at(m, pos - 1, pos - 1, max(e1, e2))
    # end)

    # elapsed_ms = div(System.system_time(:microsecond) - t0, 100) / 10

    # Logger.info("#{inspect(mx)} run max in #{elapsed_ms} ms.")
    Enum.all?([v1, v2, v3, v4])
  end
end
