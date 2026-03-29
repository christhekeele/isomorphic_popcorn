# Isomorphic Popcorn

## Repro

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
  - Await seeing in console logs: 
    - Popcorn cooked app boot log: `Starting simulation application in frontend..."`
    - or post-popcornjs init log: `Popcorn initialization finished!`
  - Instead eventually see `Uncaught Promise timeout` coming from `app.js`
  - So `IsomorphicSim.Application.start`'s `Popcorn.Wasm.register` must never get called


## Notes

- Note the fork of popcorn, which enables configuring which umbrella app is targeted for cooking.
- Note that the `MIX_TARGET` "isomorphic" part of the app currently is optional, hoisting the Popcorn init handshake outside of the conditional does not change how
  - the backend behaves (it works as Popcorn stuff just no-ops)
  - the frontend behaves (the popcorn handshake is still apparently never called/noticed)
    - therefore the issue cannot be in if the right target is set, so treat that as an illustration of how one might make isomorphic popcorn apps but not strictly part of the repro/issue

## Git Diffs

- [Changes to popcorn](https://github.com/christhekeele/popcorn/compare/7dbdc898f602d85d215e6e451954ede5648fae91...0d76982cb278c13eb979b482e89a64650f541919) to specify an umbrella app (and misc debugging)
- [The "isomorphic" part](https://github.com/christhekeele/isomorphic_popcorn/commit/7de169741d6f4e2ccbdf604d4f63a11d3b2f075d#diff-dccff4ef3c67f1e100f0c93906b456ca61cb96cad2cb005fb5ba1897d92965ecR19-R31) of `IsomorphicSim.Application`
- [The phoenix wiring](https://github.com/christhekeele/isomorphic_popcorn/commit/9b7e6d3b06496bc85b94c34d6dc88cb5b4969606#diff-4971811c177f7193428b24fa6f687c7c801808ac6f0f8b516a23b1a84dae7994R1-R17)

