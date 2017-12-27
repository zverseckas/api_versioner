defmodule RequireVersionTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ApiVersioner.RequireVersion
  alias ApiVersioner.ErrorHandler

  doctest RequireVersion

  test "creates a valid options map" do
    opts = RequireVersion.init([])
    assert Map.keys(opts) === [:error_handler]
  end

  test "has a default error handler" do
    opts = RequireVersion.init([])
    assert opts.error_handler === ErrorHandler
  end

  setup_with_mocks([{ErrorHandler, [], call: & &1}]) do
    {:ok, []}
  end

  test "calls error handler when version is not set" do
    conn =
      :get
      |> conn("/", "")
      |> RequireVersion.call(RequireVersion.init([]))

    assert called ErrorHandler.call(conn)
  end

  test "passes conn when version is set" do
    conn =
      :get
      |> conn("/", "")
      |> assign(:version, :v1)
      |> RequireVersion.call(RequireVersion.init([]))

    refute called ErrorHandler.call(conn)
  end
end
