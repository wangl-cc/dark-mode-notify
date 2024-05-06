# dark-mode-notify

A Swift program will run a command whenever the dark mode status changes on macOS.
You can use it to change your vim color config automatically for example.

## Installation

It's recommended to Homebrew to install this program:

```sh
brew tap wangl-cc/loong/dark-mode-notify
```

Alternatively, you can clone this repository and run `make install` to
build and install this program.

## Usage

This program is can run once or as a daemon.

### Run once

```sh
dark-mode-notify [<your-program> [args...]]
```

In this case, `dark-mode-notify` will run `<your-program>` once and exit.
The `[args...]` are optional arguments to pass to `<your-program>`.
And the environment variable `DARKMODE` passed to `<your-program>`,
which is either `1` or `0` based on the appearance of macOS.

If you don't specify `<your-program>`, `dark-mode-notify` will try to run
the `$HOME/.config/dark-mode-notify/notify` script.

### Run as a daemon

```sh
dark-mode-notify --daemon [<your-program> [args...]]
```

If you run `dark-mode-notify` with the `--daemon` flag will be run as a daemon.
The rest of the arguments are the same as the one-time run.

Once started as a daemon, `dark-mode-notify` will watch the dark mode status
and run the program whenever the dark mode status changes.

## Starting at login

If you want to run `dark-mode-notify` at login, it's recommended to use `brew services`:

```sh
brew services start wangl-cc/loong/dark-mode-notify
```

Make sure you have a `notify` script in `$HOME/.config/dark-mode-notify/` directory.

Or you may need to create a launch agent file in `~/Library/LaunchAgents/ke.bou.dark-mode-notify.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>ke.bou.dark-mode-notify</string>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>----Path to a location----/dark-mode-notify-stderr.log</string>
    <key>StandardOutPath</key>
    <string>----Path to a location----/dark-mode-notify-stdout.log</string>
    <key>ProgramArguments</key>
    <array>
       <string>/usr/local/bin/dark-mode-notify</string>
       <string>--- Path to your script ---</string>
    </array>
</dict>
</plist>
```

And then load it with

```sh
launchctl load -w ~/Library/LaunchAgents/ke.bou.dark-mode-notify.plist
```

## Credit

This script is a lightly modified version of <https://github.com/mnewt/dotemacs/blob/master/bin/dark-mode-notifier.swift>.
