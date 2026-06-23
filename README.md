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

## Create an admin manually (PRODUCTION)

Assuming the VM instance is deployed via fly.io (production):

Navigate to the local directory of this repository `record_verifier`, otherwise `git clone <REPO_URL>`:

```bash
cd record_verifier
fly ssh console --app record-verifier

cd /app/bin

./record_verifier remote
```

Once inside the `iex` shell, copy and paste the following:

```elixir
email = "your@email.com"
plain_password = "your_password"
hashed = Bcrypt.hash_pwd_salt(plain_password)

Ash.Seed.seed!(%RecordVerifier.Accounts.User{
  email: "your@email.com",
  hashed_password: hashed,
  confirmed_at: DateTime.utc_now()
})
```

If for some reason you can't log in because of "incorrect" password:

```elixir
Ecto.Adapters.SQL.query!(RecordVerifier.Repo, "UPDATE users SET hashed_password = '#{hashed}' WHERE email = '#{email}'")
```

Or you found out `confirmed_at` is empty:

```elixir
Ecto.Adapters.SQL.query!(RecordVerifier.Repo, "UPDATE users SET confirmed_at = NOW() WHERE email = '#{email}'")

```

Then manually set the `role` of that user to `admin` and login at https://record-verifier.fly.dev/sign-in.

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
