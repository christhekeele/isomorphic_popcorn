defmodule IsomorphicSite.Repo do
  use Ecto.Repo,
    otp_app: :isomorphic_site,
    adapter: Ecto.Adapters.Postgres
end
