defmodule RequireVersionTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  alias ApiVersioner.RequireVersion
  alias ApiVersioner.ErrorHandler

  doctest RequireVersion

  setup_with_mocks([{ErrorHandler, [], call: & &1}]) do
    {:ok, [opts: RequireVersion.init([])]}
  end

  test "creates a valid options map", %{opts: opts} do
    assert Map.keys(opts) === [:error_handler]
  end

  test "has a default error handler", %{opts: opts} do
    assert opts.error_handler === ErrorHandler
  end


  test "calls error handler when version is not set", %{opts: opts} do
    conn =
      :get
      |> conn("/", "")
      |> RequireVersion.call(opts)

    assert called ErrorHandler.call(conn)
  end

  test "passes conn when version is set", %{opts: opts} do
    conn =
      :get
      |> conn("/", "")
      |> assign(:version, :v1)
      |> RequireVersion.call(opts)

    refute called ErrorHandler.call(conn)
  end
end
