# gitui.yazi

Plugin for [Yazi](https://github.com/sxyazi/yazi) to manage git repos with [gitui](https://github.com/extrawurst/gitui)

## Dependencies

Make sure [gitui](https://github.com/extrawurst/gitui) is installed and in your `PATH`

## Installation

### Using `ya pack`

```
ya pack -a gclarkjr5/gitui
```

### Manual

#### Linux/macOS

```
git clone https://github.com/gclarkjr5/gitui.yazi.git ~/.config/yazi/plugins/gitui.yazi
```

#### Windows

```
git clone https://github.com/gclarkjr5/gitui.yazi.git %AppData%\yazi\config\plugins\gitui.yazi
```

## Configuration

add this to your **keymap.toml** file

```toml
[[manager.prepend_keymap]]
on   = [ "g", "i" ]
run  = "plugin gitui"
desc = "run gitui"
```
