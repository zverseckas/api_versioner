defmodule ApiVersioner.RequireVersion do
  import Plug.Conn

  def init(opts) do
    %{error_handler: opts[:error_handler] || &ApiVersioner.ErrorHandler.call/1}
  end

  def call(%Plug.Conn{assigns: %{version: _version}} = conn, _opts), do: conn
  def call(conn, opt), do: handle_error(conn, opt.error_handler)

  defp handle_error(conn, error_handler) do
    error_handler.(halt(conn))
  end
end
