defmodule ApiVersioner.SetVersion do
  import Plug.Conn

  @default_header "accept"

  def init(opts) do
    %{
      accepts: opts[:accepts] || %{},           # Accepted versions
      default: opts[:default],                  # Default version
      header: opts[:header] || @default_header  # HTTP header to check
     }
  end

  def call(conn, opts) do
    header_value = get_header(conn, opts.header)
    case Map.fetch(opts.accepts, header_value) do
      {:ok, [version]} ->
        set_version(conn, version)

      _error ->
        set_default(conn, opts)
    end
  end

  defp set_default(conn, opts) do
    # If default version is accepted
    if Map.values(opts.accepts) |> Enum.member?([opts.default]) do
      set_version(conn, opts.default)
    else
      conn
    end
  end

  defp set_version(conn, version) do
    assign(conn, :version, version)
  end

  defp get_header(conn, header) do
    case get_req_header(conn, header) do
      [header_value] -> header_value
      _error -> nil
    end
  end
end
