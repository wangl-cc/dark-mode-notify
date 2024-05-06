// The program will have the DARKMODE env flag set to 1 or 0
// Compile with:
// swift build
// And run the binary directly
// Most credit goes to https://github.com/mnewt/dotemacs/blob/master/bin/dark-mode-notifier.swift

import Cocoa

@discardableResult
func shell(_ args: [String]) -> Int32 {
  let task = Process()
  let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
  var env = ProcessInfo.processInfo.environment
  env["DARKMODE"] = isDark ? "1" : "0"
  task.environment = env
  task.launchPath = "/usr/bin/env"
  task.arguments = args
  task.standardError = FileHandle.standardError
  task.standardOutput = FileHandle.standardOutput
  task.launch()
  task.waitUntilExit()
  return task.terminationStatus
}

func prepareArgs(_ args: [String]) -> [String] {
  return if args.isEmpty {
    [NSHomeDirectory() + "/.config/dark-mode-notify/notify"]
  } else {
    args
  }
}

let args = Array(CommandLine.arguments.suffix(from: 1))

// if the first argument is not --daemon, run the command and exit
if args.first != "--daemon" {
  shell(prepareArgs(args))
  exit(0)
}


// if the first argument is --daemon, run the command if the theme changes
let serveArgs = Array(prepareArgs(Array(args.suffix(from: 1))))

DistributedNotificationCenter.default.addObserver(
  forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
  object: nil,
  queue: nil) { (notification) in shell(serveArgs) }

NSWorkspace.shared.notificationCenter.addObserver(
  forName: NSWorkspace.didWakeNotification,
  object: nil,
  queue: nil) { (notification) in shell(serveArgs) }

NSApplication.shared.run()
