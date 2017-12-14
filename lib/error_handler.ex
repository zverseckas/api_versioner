defmodule ApiVersioner.ErrorHandler do
  import Plug.Conn

  def call(conn) do
    conn
    |> send_resp(406, "Not Acceptable")
  end
end
