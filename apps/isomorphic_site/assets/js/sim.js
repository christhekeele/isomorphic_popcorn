import { Popcorn } from "./popcorn/popcorn.js";

console.log("Initializing popcorn...")
await Popcorn.init({
  bundlePath: "/assets/popcorn/bundle.avm",
  wasmDir: "/assets/popcorn/",
  onStdout: console.log,
  onStderr: console.error,
  debug: true,
});
