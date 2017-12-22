defmodule ApiVersioner.ErrorHandler do
  @moduledoc """
    `ApiVersioner.ErrorHandler` is a default Error handler for
    the `ApiVersioner.ReqioreVersion` plug. The module implements
    a `call` function that takes and returns a `%Plug.Conn`.

    The `call` function in this case sets the HTTP reponse status
    code to `406` and its body to `"Not Acceptable"`.
  """

  import Plug.Conn

  @doc false
  def call(conn) do
    conn
    |> send_resp(406, "Not Acceptable")
  end
end
