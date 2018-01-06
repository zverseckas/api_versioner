defmodule ApiVersioner.SetVersion do
  @moduledoc """
    `ApiVersioner.SetVersion` is a *plug* module for setting an API version.
    The module allows the API version identifier to be stored inside of the
    `:assigns` map within the `%Plug.Conn{}` structure.

    Identification of a requested API version is done by reading a specified
    HTTP request header. If a value inside of the the header corresponds to at
    least one of the application's mime types, the extension of the mime type
    is considered to be the API version.

    For example if the aplication's mimes are set to:

      config :mime, :types, %{
        "application/vnd.app.v1+json" => [:v1],
        "application/vnd.app.v2+json" => [:v2]
      }

    and the API versioner's configuration is done the following way:

      plug ApiVersioner.SetVersion, accepts: [:v1, :v2], header: "accept"

    then whenever the *Accept* header is either
    `Accept: "application/vnd.app.v1+json"` or
    `Accept: "application/vnd.app.v2+json"` the API version will be set
    either to `:v1` or `:v2` correspondingly.

    It is important to note that the `:header` option can be omitted
    when used HTTP header is *Accept*:

      # Uses the 'Accept' header by default
      plug ApiVersioner.SetVersion, accepts: [:v1, :v2]

    Also, as a fallback situation when no version can be determined the
    `default` option can come in handy:

      # When no version is found API version will be set to default :v1
      plug ApiVersioner.SetVersion, accepts: [:v1, :v2], default: :v1

    In some cases API version can be set by simply omitting all the options
    except for the `:default`. This way the version will just be set to the
    default value if it is present among application's mime types.
  """

  import Plug.Conn

  # Default HTTP header to check
  @default_header "accept"

  @doc false
  def init(opts) do
    %{
      accepts: opts[:accepts] || [],           # Accepted versions
      default: opts[:default],                 # Default version
      header: opts[:header] || @default_header # HTTP header to check
     }
  end

  @doc false
  def call(conn, opts) do
    header_value = get_header(conn, opts.header)
    case MIME.extensions(header_value) do
      [version | _tail] ->
        set_version(conn, version)
      [] ->
        set_default(conn, opts.default)
    end
  end

  # Returns a value of a given HTTP header
  defp get_header(conn, header) do
    case get_req_header(conn, header) do
      [header_value | _tail] ->
        header_value
      [] ->
        nil
    end
  end

  # Set version to a given value
  defp set_version(conn, version) do
    assign(conn, :version, version)
  end

  # Sets version to default if default is valid
  defp set_default(conn, default) do
    if MIME.has_type?(default) do
      set_version(conn, default)
    else
      conn
    end
  end
end
