defmodule ApiVersioner.RequireVersion do
  @moduledoc """
    `ApiVersioner.RequireVersion` is a *plug* module for requiring an API
    version. The version is expected to be present on `conn.assigns.version`
    where the `conn` is a `%Plug.Conn{}` structure.

    The plug can be used the following way:

      plug ApiVersioner.RequireVersion, error_handler: MyErrorHandler

    where the `:error_handler` option determines the handler to be used
    when the version is not determined. The `:error_handler` defaults to
    `ApiVersioner.ErrorHandler` when not set.

    There are three requirements for the `:error_handler` module:
    * It should provider a function called `call`.
    * This function should take a `%Plug.Conn{}` as a single argument.
    * This function should return a `%Plug.Conn{}`.
  """

  @doc false
  def init(opts) do
    %{error_handler: opts[:error_handler] || ApiVersioner.ErrorHandler}
  end

  @doc false
  def call(%Plug.Conn{assigns: %{version: _version}} = conn, _opts), do: conn
  def call(conn, opt), do: handle_error(conn, opt.error_handler)

  defp handle_error(conn, error_handler) do
    apply(error_handler, :call, conn)
  end
end
