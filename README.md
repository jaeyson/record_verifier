# RecordVerifier

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Build web server

```bash
cp .env.example .env
source .env

mix deps.get

# on your web server
iex -S mix phx.server
```

## Enable VPN (Tailscale)

> [!NOTE]
> Make sure to **enable** `MagicDNS` located at https://login.tailscale.com/admin/dns before doing the following commands below in order to avoid DNS errors.

```bash
# on another terminal tab
tailscale funnel 4000
```

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
