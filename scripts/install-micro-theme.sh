#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd -- "$script_dir/.." && pwd)"
theme_src="$repo_dir/micro/purple-rain.micro"
config_root="${XDG_CONFIG_HOME:-$HOME/.config}"
micro_config_dir="$config_root/micro"
colorschemes_dir="$micro_config_dir/colorschemes"
settings_file="$micro_config_dir/settings.json"

mkdir -p "$colorschemes_dir"
cp "$theme_src" "$colorschemes_dir/purple-rain.micro"

tmp_settings="$(mktemp)"

SETTINGS_FILE="$settings_file" TMP_SETTINGS="$tmp_settings" node <<'EOF'
const fs = require("fs");

const settingsFile = process.env.SETTINGS_FILE;
const tmpSettings = process.env.TMP_SETTINGS;
let settings = {};

if (fs.existsSync(settingsFile)) {
  const raw = fs.readFileSync(settingsFile, "utf8").trim();
  if (raw) {
    try {
      settings = JSON.parse(raw);
    } catch (error) {
      console.error(`Failed to parse ${settingsFile}: ${error.message}`);
      process.exit(1);
    }
  }
}

settings.colorscheme = "purple-rain";
fs.writeFileSync(tmpSettings, `${JSON.stringify(settings, null, 2)}\n`);
EOF

mkdir -p "$micro_config_dir"
mv "$tmp_settings" "$settings_file"

printf 'Installed Micro theme to %s\n' "$colorschemes_dir/purple-rain.micro"
printf 'Updated %s with colorscheme \"purple-rain\"\n' "$settings_file"
