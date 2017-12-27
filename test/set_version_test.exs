defmodule SetVersionTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ApiVersioner.SetVersion

  doctest SetVersion

  setup _opts do
    {:ok,
      [
        opts: SetVersion.init([]),
        no_default: SetVersion.init(
          accepts: ~w(test1 test2)a
        ),
        with_default: SetVersion.init(
          accepts: ~w(test1 test2)a,
          default: :test1
        )
      ]
    }
  end

  test "creates a valid options map", %{opts: opts} do
    assert Map.keys(opts) === [:accepts, :default, :header]
  end

  test "default header is Accept", %{opts: %{header: header}} do
    assert header === "accept"
  end

  test_with_mock "sets version when a valid given", %{no_default: opts},
    MIME, [], [
      extensions: fn ("Test1") -> [:test1] end
    ] do

    conn =
      :get
      |> conn("/", "")
      |> put_req_header("accept", "Test1")
      |> SetVersion.call(opts)

    assert conn.assigns.version === :test1
  end

  test "does not set version when invalid", %{no_default: opts} do
    conn =
      :get
      |> conn("/", "")
      |> SetVersion.call(opts)

    refute conn.assigns[:version]
  end

  test_with_mock "sets default version", %{with_default: opts},
    MIME, [], [
      has_type?: fn(:test1) -> true end,
      extensions: fn(_type) -> [] end
    ] do

    conn =
      :get
      |> conn("/", "")
      |> SetVersion.call(opts)

    assert conn.assigns.version === :test1
  end
end
