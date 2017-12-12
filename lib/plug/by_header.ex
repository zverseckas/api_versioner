defmodule ApiVersioner.ByHeader do
  import ApiVersioner.Helpers
  import Plug.Conn

  def init(opt) do
    %{
      accepts: opt[:accepts] || [],      # Accepted versions
      default: opt[:default],            # Default version
      header:  opt[:header] || "accept"  # HTTP header containing a version
    }
  end

  def call(conn, opt) do
    [header_value] = get_req_header(conn, opt.header)
    case Map.fetch(opt.accepts, header_value) do
      {:ok, version} ->
        set_version(conn, version)
      :error ->
        if Map.values(opt.accepts) |> Enum.member?([opt.default]) do
          set_version(conn, opt.default)
        else
          not_acceptable(conn)
        end
    end
  end
end
