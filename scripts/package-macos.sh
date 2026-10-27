#!/bin/bash
#
# Packages a macOS build into a self-contained folder:
#
#   <out>/Engine Sim.command   double-click launcher
#   <out>/bin/                 engine-sim-app, delta.conf and bundled dylibs
#   <out>/assets, es, basic    scripts, engines, fonts and shaders
#
# Usage: scripts/package-macos.sh <build dir> <output dir>
# Needs Homebrew's dylibbundler and sdl3 (pulled in by sdl2-compat).

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$1"
OUT_DIR="$2"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/bin/libs" "$OUT_DIR/basic"

cp "$BUILD_DIR/engine-sim-app" "$OUT_DIR/bin/"
# Engine (fonts/shaders) directory, then the assets directory
printf '../basic\n../assets\n' > "$OUT_DIR/bin/delta.conf"

cp -R "$REPO_DIR/assets" "$REPO_DIR/es" "$OUT_DIR/"
cp -R "$REPO_DIR/dependencies/submodules/delta-studio/engines/basic/fonts" \
      "$REPO_DIR/dependencies/submodules/delta-studio/engines/basic/shaders" \
      "$OUT_DIR/basic/"
find "$OUT_DIR" -name .DS_Store -delete

# Copy Homebrew dylibs next to the binary and point the binary at them
dylibbundler -od -b -cd \
    -x "$OUT_DIR/bin/engine-sim-app" \
    -d "$OUT_DIR/bin/libs" \
    -p @executable_path/libs/

# sdl2-compat loads SDL3 at runtime from its own folder as libSDL3.dylib
cp "$(brew --prefix sdl3)/lib/libSDL3.0.dylib" "$OUT_DIR/bin/libs/libSDL3.dylib"
chmod u+w "$OUT_DIR/bin/libs/"*.dylib
install_name_tool -id @loader_path/libSDL3.dylib "$OUT_DIR/bin/libs/libSDL3.dylib"

# Rewriting install names invalidates signatures; arm64 requires one
codesign --force --sign - "$OUT_DIR/bin/libs/"*.dylib "$OUT_DIR/bin/engine-sim-app"

cat > "$OUT_DIR/Engine Sim.command" <<'EOF'
#!/bin/bash
cd "$(dirname "$0")/bin" && exec ./engine-sim-app
EOF
chmod +x "$OUT_DIR/Engine Sim.command" "$OUT_DIR/bin/engine-sim-app"
