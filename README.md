# VaultLogin
- Elixir package exposing an `auth: 2` function taking a username and password returning tuple
`{:ok, authInfo}` if login is sucessful.
- Locates Vault via `VAULT_ADDR` environment variable.  

## Installation

  1. Add phoenix_vault_login to your list of dependencies in `mix.exs`:

        def deps do
          [{:phoenix_vault_login, git: "git://github.com/harmon25/phoenix_vault_login.git"}]
        end

