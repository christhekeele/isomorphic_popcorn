# Isomorphic Popcorn

Repro:

- Install versions of things listed in `.tool-versions`
- `mix deps.get`
- `cd apps/isomorphic_sim` and run:
  - `env MIX_TARGET=wasm mix popcorn.cook`
- `cd apps/isomorphic_site` and run:
  - `mix setup`
  - `mix assets.build`
  - `mix phx.copy popcorn`
  - `mix phx.server`
  - See in server logs: `Starting simulation application in backend...`
- Navigate to `https://localhost:4000`
  - Await seeing in console logs: `"Running simulation application in frontend..."`
  - Instead eventually see `Uncaught Promise timeout` coming from `sim.js`
  - So `IsomorphicSim.Application.start`'s `Popcorn.Wasm.register` must never get called

Note the fork of popcorn, which enables configuring which umbrella app is targeted.