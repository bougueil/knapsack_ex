# Knapsack
[![Test](https://github.com/bougueil/knapsack_ex/actions/workflows/ci.yml/badge.svg)](https://github.com/bougueil/knapsack_ex/actions/workflows/ci.yml)

Matrix manipulation with elixir.

Several matrix implementations (including Nx) are compared for the resolution of a [simplex](https://en.wikipedia.org/wiki/Knapsack_problem) algorithm.


## run
```bash
mix deps.get
mix test
```

## run the knapsack algorithm
```bash
mix deps.get
iex -S mix
iex(1)> Knapsack.run(MatrixMapTuple)
iex(1)> Knapsack.run(Matrix.Nx)
```


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `knapsack_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:knapsack_ex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/knapsack_ex](https://hexdocs.pm/knapsack_ex).