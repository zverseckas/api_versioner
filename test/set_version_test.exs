defmodule SetVersionTest do
  use ExUnit.Case, async: true
  use Plug.Test

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
		  		accepts: %{
		  			"Test1" => [:test1],
		  			"Test2" => [:test2]
		  		}
		  	),
		  	with_default: SetVersion.init(
		  		accepts: %{
	  				"Test1" => [:test1],
	  				"Test2" => [:test2]
		  		},
		  		default: :test1
	  		)
	  	]
		}
  end

  test "sets version when a valid one provided", opts do
  	conn =
  		conn(:get, "/", "")
	  	|> put_req_header("accept", "Test1")
	  	|> SetVersion.call(opts[:no_default])

	  assert conn.assigns.version === :test1
  end

  test "does not set version when not provided", opts do
  	conn =
  	 conn(:get, "/", "")
  	 |> SetVersion.call(opts[:no_default])

  	refute conn.assigns[:version]
  end

   test "sets version when not provided but default exists", opts do
  	conn =
  	 conn(:get, "/", "")
  	 |> SetVersion.call(opts[:with_default])

  	assert conn.assigns.version === :test1
  end
end
