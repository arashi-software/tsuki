# Tsuki - ムーン
### Tsuki is a fast and opinionated theme switcher for linux

## Requirements
- nim (build)
- nimble (usually provided with nim) (build)

## Installation
Currently tsuki can only be built from source.
```bash
git clone https://github.com/arashi-software/tsuki; cd tsuki
nimble install
```

# Setup 
Tsuki requires a config file in json at `$HOME/.tsuki/themes.tsk`. This file tells tsuki where to map the files to and what command to run after it is finished
```js
{
  "files": [ // The files array stores a list of objects which contain a path to the source file and a path to the dest file
    {
      "dest": "~/.config/dk/dkrc",
      "src": "*/dkrc" // The asterisk charecter is a placeholder for the current theme name
    },
    {
      "dest": "~/.config/eww/_colors.scss",
      "src": "*/_colors.scss"
    }
  ],
  "commands": [ // These command would be run after tsuki is finished switching the theme, you can put commands here to restart your apps.
    "eww reload",
    "dkcmd restart"
  ]
}
```
Tsuki is opinionated with how the file structure works. Running tree in the ~/.tsuki directory returns
```txt
/home/luke/.tsuki
├── themes
│   ├── dark
│   │   ├── _colors.scss
│   │   ├── config.rasi
│   │   ├── dkrc
│   │   ├── dunstrc
│   │   ├── settings.json
│   │   ├── wallpaper.png
│   │   └── wezterm.lua
│   └── light
│       ├── _colors.scss
│       ├── config.rasi
│       ├── dkrc
│       ├── dunstrc
│       ├── settings.json
│       ├── wallpaper.png
│       └── wezterm.lua
└── themes.tsk
```
In this case there are 2 valid themes, light and dark, the directory structure of both of these should be the same with the only modification being done to the files themselves. This is so that tsuki can use the theme placeholders without running into an error.

## Usage
After tsuki has been setup you can use it through its command line interface
```bash
tsuki <theme>
tsuki flip
```
Or through rofi
```bash
tsuki rofi
```

## Todo
- [x] Basic theme switching
- [ ] Template engine
- [x] Rofi frontend
- [ ] fzf frontened

## Leave a star if you like tsuki ⭐
