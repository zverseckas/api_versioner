defmodule ErrorHandlerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ApiVersioner.ErrorHandler

  doctest ErrorHandler

  test "sets http status to 406" do
    conn =
      :get
      |> conn("/", "")
      |> ErrorHandler.call

    assert conn.status === 406
  end

  test "sets reponse to 'Not Acceptable'" do
    conn =
      :get
      |> conn("/", "")
      |> ErrorHandler.call

    assert conn.resp_body === "Not Acceptable"
  end
end
