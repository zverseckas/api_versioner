defmodule ApiVersioner.ByHeader do
  import Plug.Conn

  def init(opt) do
    %{accepts: opt[:accepts] || [],
      default: opt[:default],
      header:  opt[:header] || "accept"}
  end

  def call(conn, opt) do
    [header_val] = get_req_header(conn, opt.header)
    case Map.fetch(header_val, opt.accepts) do
      {:ok, version} ->
        set_version(conn, version)
      :error ->
        if Map.values(opt.accepts) |> Enum.member?(opt.default) do
          set_version(conn, opt.default)
        else
          not_acceptable(conn)
        end
    end
  end

  defp set_version(conn, version) do
    assign(conn, :version, version)
  end

  defp not_acceptable(conn) do
    conn |> send_resp(406, "Not Acceptable")
  end
end
