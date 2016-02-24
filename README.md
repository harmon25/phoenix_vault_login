# VaultLogin
- Elixir package exposing an `auth: 2` function taking a username and password returning tuple
`{:ok, authInfo}` if login is sucessful.
- Locates Vault via `VAULT_ADDR` environment variable.  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add phoenix_vault_login to your list of dependencies in `mix.exs`:

        def deps do
          [{:phoenix_vault_login, git: "git://github.com/elixir-lang/plug.git"}]
        end

  2. Ensure phoenix_vault_login is started before your application:

        def application do
          [applications: [:phoenix_vault_login]]
        end

