defmodule ApiVersioner.Helpers do
  import Plug.Conn
  
  def set_version(conn, version) do
    conn
    |> assign(:version, version)
  end

  def not_acceptable(conn) do
    conn
    |> send_resp(406, "Not Acceptable")
    |> halt
  end
end
