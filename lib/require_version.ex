defmodule ApiVersioner.RequireVersion do
  import Plug.Conn

  def init(opts) do
    %{error_handler: opts[:error_handler] || ApiVersioner.ErrorHandler}
  end

  def call(%Plug.Conn{assigns: %{version: version}} = conn, opts) do
    if version, do: conn, else: handle_error(conn, opts)
  end

  defp handle_error(conn, opts) do
    apply(opts.error_handler, :call, [halt(conn)])
  end
end
