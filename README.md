# Move Stylus Sample Projects

Sample Move smart contracts for [Arbitrum Stylus](https://docs.arbitrum.io/stylus/gentle-introduction), built with [move-stylus](https://github.com/rather-labs/move-stylus) (Rather Labs).

## Prerequisites

- [Rust](https://rustup.rs/) (toolchain 1.88.0 used by move-stylus)
- [move-stylus](https://github.com/rather-labs/move-stylus) CLI

### Install move-stylus CLI

```bash
# Install cargo-stylus for deployment (optional, for deploy)
RUSTFLAGS="-C link-args=-rdynamic" cargo install --force --version 0.6.3 cargo-stylus

# Clone and install move-stylus compiler + CLI
git clone https://github.com/rather-labs/move-stylus
cd move-stylus
cargo install --locked --path crates/move-cli
```

Verify: `move-stylus --version`

If you have the [move-stylus](https://github.com/rather-labs/move-stylus) repo cloned locally but not installed:

```bash
cd /path/to/move-stylus
cargo run -p move-cli -- build -p /path/to/move-stylus-samples/counter
cargo run -p move-cli -- test -p /path/to/move-stylus-samples/counter
```

## Projects

| Project           | Description |
|-------------------|-------------|
| `counter/`        | Shared counter: create, increment, read, set_value (owner-only); unit tests. |
| `hello/`          | Minimal "hello world" Move module. |
| `vault/`          | Shared vault: anyone can deposit, only owner can withdraw; unit tests. |
| `counter_owned/`  | Owned counter: created in `init`, transferred to sender; increment, read, set_value. |

## Build & Test

From this repo root, for each project:

```bash
cd counter
move-stylus build
move-stylus test
```

Or run all: `./scripts/build-and-test.sh`

Same for `hello/`, `vault/`, `counter_owned/`.

The move-stylus CLI automatically pulls **MoveStdlib** and **StylusFramework** from the [move-stylus repo](https://github.com/rather-labs/move-stylus); no extra deps in `Move.toml` are required.

## Deploy (optional)

With [Arbitrum Nitro devnode](https://docs.arbitrum.io/run-arbitrum-node/run-nitro-dev-node) running and [Foundry](https://book.getfoundry.sh/) installed:

```bash
cd counter
move-stylus build
move-stylus deploy --contract-name counter --private-key <YOUR_DEV_KEY>
# Then interact with cast send / cast call
```

## Docs

- [Move for Stylus documentation](https://rather-labs.github.io/move-stylus-docs/)
- [move-stylus GitHub](https://github.com/rather-labs/move-stylus)

## License

Sample code: MIT or Apache-2.0. move-stylus itself is BSL 1.1 (Rather Labs).
