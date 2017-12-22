defmodule SetVersionTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ApiVersioner.SetVersion

  doctest SetVersion

  test "creates a valid options map" do
    opts = SetVersion.init([])
    assert Map.keys(opts) === [:accepts, :default, :header]
  end

  test "default header is Accept" do
    %{header: header} = SetVersion.init([])
    assert header === "accept"
  end

  setup _opts do
    {:ok,
      [
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

  test "sets version when a valid one provided", opts do
    with_mock MIME, extensions: fn ("Test1") -> [:test1] end do
      conn =
        :get
        |> conn("/", "")
        |> put_req_header("accept", "Test1")
        |> SetVersion.call(opts[:no_default])

      assert conn.assigns.version === :test1
    end
  end

  test "does not set version when not provided", opts do
    conn =
      :get
      |> conn("/", "")
      |> SetVersion.call(opts[:no_default])

    refute conn.assigns[:version]
  end

   test "sets version when not provided but default exists", opts do
    with_mock MIME, has_type?: fn(:test1) -> true end,
                    extensions: fn(_type) -> [] end do
      conn =
        :get
        |> conn("/", "")
        |> SetVersion.call(opts[:with_default])

      assert conn.assigns.version === :test1
    end
  end
end
