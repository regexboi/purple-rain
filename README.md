# purple-rain

A deep royal purple theme with vibrant neon syntax colors for **Cursor**, **VS Code**, and **Warp Terminal**.

## Preview

| Element | Color |
|---------|-------|
| Background | `#1a0533` — deep royal purple |
| Foreground | `#e8e0f0` — soft lavender white |
| Keywords | `#ff59d6` — neon pink |
| Strings | `#00ff87` — neon green |
| Functions | `#59b8ff` — electric blue |
| Numbers | `#ffda45` — bright yellow |
| Types | `#ffda45` — golden yellow |
| Operators | `#00e5ff` — electric cyan |
| Comments | `#a78bfa` — brighter lavender |
| Accent | `#b44dff` — vibrant purple |

## Install — Cursor / VS Code

### Option 1: From this repo (build + install)

```bash
# Clone, build, and install
git clone https://github.com/regexboi/purple-rain.git
cd purple-rain
pnpm run build:vsix
code --install-extension ./purple-rain-1.0.8.vsix    # VS Code
cursor --install-extension ./purple-rain-1.0.8.vsix  # Cursor
```

### Option 2: Install the release `.vsix`

```bash
# Download the .vsix asset from GitHub Releases, then:
code --install-extension purple-rain-1.0.8.vsix   # VS Code
cursor --install-extension purple-rain-1.0.8.vsix  # Cursor
```

If install fails, verify you downloaded the release asset (not an HTML page):

```bash
file purple-rain-1.0.8.vsix
# should say: Zip archive data
```

### Option 2b: Build locally and install into Cursor

```bash
# From this repo:
npm run build:vsix
cursor --install-extension ./purple-rain-1.0.8.vsix
```

### Option 3: Symlink for development

```bash
# macOS / Linux
ln -s "$(pwd)" ~/.vscode/extensions/purple-rain
# or for Cursor:
ln -s "$(pwd)" ~/.cursor/extensions/purple-rain
```

Then restart and select **purple-rain** from the color theme picker (`Cmd+Shift+P` → "Preferences: Color Theme").

## Install — Warp Terminal

Copy `warp/purple_rain.yaml` to your Warp themes directory:

```bash
# macOS
cp warp/purple_rain.yaml ~/.warp/themes/

# Linux
cp warp/purple_rain.yaml ~/.local/share/warp-terminal/themes/

# Windows
copy warp\purple_rain.yaml %APPDATA%\warp\Warp\data\themes\
```

Restart Warp and select **purple-rain** in Settings → Appearance.

## License

MIT
