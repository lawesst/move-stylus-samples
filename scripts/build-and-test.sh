#!/usr/bin/env bash
# Build and test all sample projects. Requires move-stylus CLI in PATH.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v move-stylus &>/dev/null; then
  echo "move-stylus not found. Install from: https://github.com/rather-labs/move-stylus"
  echo "  cd move-stylus && cargo install --locked --path crates/move-cli"
  exit 1
fi

for dir in counter hello vault counter_owned; do
  if [[ -d "$dir" ]] && [[ -f "$dir/Move.toml" ]]; then
    echo "=== $dir ==="
    (cd "$dir" && move-stylus build && move-stylus test)
  fi
done
echo "Done."
