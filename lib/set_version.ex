defmodule ApiVersioner.SetVersion do
  import Plug.Conn

  @default_header "accept"

  def init(opts) do
    %{
      accepts: opts[:accepts] || [],            # Accepted versions
      default: opts[:default],                  # Default version
      header: opts[:header] || @default_header  # HTTP header to check
     }
  end

  def call(conn, opts) do
    [heade_value] = get_req_header(conn, opts.header)
    case Map.fetch(opts.accepts, heade_value) do
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
end
