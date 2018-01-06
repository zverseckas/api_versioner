# ApiVersioner
[![Build Status](https://travis-ci.org/zverseckas/api_versioner.svg?branch=master)](https://travis-ci.org/zverseckas/api_versioner)
[![Coverage Status](https://coveralls.io/repos/github/zverseckas/api_versioner/badge.svg?branch=master)](https://coveralls.io/github/zverseckas/api_versioner?branch=master)

Module for setting versions to Elixir [Plug](https://github.com/elixir-plug/plug) and [Phoenix](http://phoenixframework.org/) based API's. Uses HTTP headers and [MIME](https://github.com/elixir-plug/mime) types.

## Installation
Package is not yet available on [Hex](https://hex.pm/) but it can be downloaded from [GitHub](https://github.com).
```elixir
def deps do
  [
    {:api_versioner, git: "https://github.com/zverseckas/api_versioner.git", tag: "0.1.0"}
  ]
end
```

## Usage
`ApiVersioner` uses [MIME](https://github.com/elixir-plug/mime) types for API version verification. In your application you can set something like:
```elixir
config :mime, :types, %{
  "application/vnd.app.v1+json" => [:v1],
  "application/vnd.app.v2+json" => [:v2]
}
```
**Please note!** As stated in [MIME documentation](https://github.com/elixir-plug/mime#usage) it is necessary to recompile the `mime` library  whenever you change media type configurations.

With `mime` types configured, `ApiVersioner` can be used as a [Plug](https://github.com/elixir-plug/plug).

### Plug applications
```elixir
defmodule MyApi.MyRouter do
  plug ApiVersioner.SetVersion, accepts: [:v1, :v2], default: :v1, header: "accept"
  plug ApiVersioner.RequireVersion, error_handler: MyErrorHandler
end
```
### Phoenix applications
```elixir
defmodule MyApi.Router do
  use MyApi.Web, :router

  pipeline :api do
    plug ApiVersioner.SetVersion, accepts: [:v1]
    plug ApiVersioner.RequireVersion
  end
end
```
## Tests & coverage
Tests gen be ran by
```
$~ mix test
$~ mix coveralls
```
## Documentation
HTML documentation is generated using [ExDoc](https://github.com/elixir-lang/ex_doc) by running
```
$~ mix docs
```
## Module API
Todo: Add docs.
