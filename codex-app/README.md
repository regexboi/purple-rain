# purple-rain for Codex

Codex app theme presets built from the Purple Rain palette.

All variants keep the same base surface:

- `surface`: `#1a0533`
- `codeThemeId`: `tokyo-night`
- `opaqueWindows`: `false`

Theme groups:

High readability:

- `purple-rain-classic.theme` - pink accent with lavender ink
- `purple-rain-frostbite.theme` - bright cyan accent with lavender ink
- `purple-rain-gold-flash.theme` - yellow accent with electric blue ink
- `purple-rain-laser-lemon.theme` - yellow accent with lavender ink

Balanced neon:

- `purple-rain-aurora-mint.theme` - mint accent with electric blue ink
- `purple-rain-blue-hour.theme` - electric blue accent with bright pink ink
- `purple-rain-cyan-surge.theme` - cyan accent with bright pink ink
- `purple-rain-lavender-haze.theme` - purple accent with mint ink
- `purple-rain-sunset-spark.theme` - coral accent with yellow ink
- `purple-rain-ultraviolet.theme` - indigo accent with mint ink

Max chaos:

- `purple-rain-cotton-candy.theme` - bright pink accent with yellow ink
- `purple-rain-neon-mix.theme` - pink accent with cyan ink
- `purple-rain-neon-royale.theme` - vibrant purple accent with cyan ink
- `purple-rain-orchid-ice.theme` - pink accent with bright cyan ink

Each file is a single-line `codex-theme-v1:` payload for direct import or paste.

## Apply A Theme

Set one of these presets as the current Codex app theme:

```bash
./scripts/set-codex-theme.sh
```

What it does:

- Shows a grouped numbered picker for the available presets
- Prints a small terminal preview table for background, accent, and text colors
- Writes the selected dark theme into:

```bash
~/.codex/.codex-global-state.json
```

Important warning:

- If Codex is already running, the script force-kills Codex and relaunches it
- This interrupts any running Codex threads, automations, or pending work
- The interactive picker warns about this and asks for `y/n` confirmation before applying

Useful options:

```bash
./scripts/set-codex-theme.sh --list
./scripts/set-codex-theme.sh purple-rain-classic
./scripts/set-codex-theme.sh codex-app/purple-rain-neon-royale.theme
```

Restart Codex after applying a new theme if the change does not show immediately.
