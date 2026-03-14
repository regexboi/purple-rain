# purple-rain

A deep royal purple theme with vibrant neon syntax colors for **Cursor**, **VS Code**, **Warp Terminal**, **Ghostty**, and **Micro**.

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
pnpm run build:vsix
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

## Install — Codex App

Set one of the Codex presets as the current Codex app theme:

```bash
./scripts/set-codex-theme.sh
```

What it does:

- Shows a grouped numbered picker for the available Codex presets
- Lets you preview each preset by background, accent, and text color in the terminal
- Writes the selected dark theme into:

```bash
~/.codex/.codex-global-state.json
```

Important warning:

- If Codex is open, the script force-kills Codex and relaunches it
- This interrupts any running Codex threads, automations, or pending work
- The interactive picker warns about this and asks for `y/n` confirmation before applying

Direct usage:

```bash
./scripts/set-codex-theme.sh --list
./scripts/set-codex-theme.sh purple-rain-classic
./scripts/set-codex-theme.sh codex-app/purple-rain-neon-royale.theme
```

Restart Codex if the updated theme does not appear immediately.

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

## Install — Ghostty

Ghostty custom themes are plain Ghostty config files. Per the Ghostty docs, custom theme files are discovered from `~/.config/ghostty/themes/` and enabled via the `theme` setting in `~/.config/ghostty/config`.

Copy `ghostty/purple-rain` into your Ghostty themes directory:

```bash
# macOS / Linux
mkdir -p ~/.config/ghostty/themes
cp ghostty/purple-rain ~/.config/ghostty/themes/purple-rain
```

Then enable it by adding this exact line to `~/.config/ghostty/config`:

```conf
theme = purple-rain
```

Use the lowercase `purple-rain` name here. Ghostty also ships a different built-in theme named `Purple Rain`.

If you want to verify Ghostty can see it:

```bash
ghostty +list-themes | rg 'purple-rain'
ghostty +validate-config
```

On macOS, relaunch Ghostty after copying the theme or open a new instance:

```bash
open -na Ghostty.app
```

## Install — Micro

Micro custom themes are plain `.micro` files stored in `~/.config/micro/colorschemes` and activated via the `colorscheme` setting in `~/.config/micro/settings.json`.

Use the installer script from this repo:

```bash
./scripts/install-micro-theme.sh
```

What it does:

- Copies `micro/purple-rain.micro` into `~/.config/micro/colorschemes/purple-rain.micro`
- Creates or updates `~/.config/micro/settings.json`
- Sets `"colorscheme": "purple-rain"` without removing unrelated Micro settings

Manual install:

```bash
mkdir -p ~/.config/micro/colorschemes
cp micro/purple-rain.micro ~/.config/micro/colorschemes/purple-rain.micro
```

Then ensure `~/.config/micro/settings.json` contains:

```json
{
  "colorscheme": "purple-rain"
}
```

This theme is designed for true-color terminals. If your terminal supports it, `COLORTERM=truecolor` will give the closest match to the rest of the purple-rain palette.

## License

MIT
