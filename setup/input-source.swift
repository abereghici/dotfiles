// Make ABC – Romanian (keyboard/ABC-Romanian.keylayout) the only keyboard layout: enable and
// select it, then disable every other keyboard layout (ABC included). Input methods such as
// press-and-hold are left alone. Run by symlinks.sh after the layout is linked.
import Carbon
import Foundation

let layoutID = "org.unknown.keylayout.ABC–Romanian"
let layoutURL = FileManager.default.homeDirectoryForCurrentUser
  .appendingPathComponent("Library/Keyboard Layouts/ABC-Romanian.keylayout")

func keyboardLayouts() -> [TISInputSource] {
  let filter = [kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String] as CFDictionary
  return TISCreateInputSourceList(filter, true).takeRetainedValue() as! [TISInputSource]
}

func property(_ source: TISInputSource, _ key: CFString) -> AnyObject? {
  TISGetInputSourceProperty(source, key).map { Unmanaged<AnyObject>.fromOpaque($0).takeUnretainedValue() }
}

func id(_ source: TISInputSource) -> String {
  property(source, kTISPropertyInputSourceID) as? String ?? ""
}

// A layout linked since the last login isn't known to the system yet
if !keyboardLayouts().contains(where: { id($0) == layoutID }) {
  TISRegisterInputSource(layoutURL as CFURL)
}

func isEnabled(_ source: TISInputSource) -> Bool {
  property(source, kTISPropertyInputSourceIsEnabled) as? Bool == true
}

// Every enable, select or disable makes macOS open System Settings → Keyboard, so change
// only what isn't already so (a set-up Mac gets no calls at all)
let layouts = keyboardLayouts()
let targets = layouts.filter { id($0) == layoutID }
guard !targets.isEmpty else {
  print("ABC – Romanian isn't registered yet: log out and back in, then run setup/symlinks.sh again")
  exit(1)
}

// The same layout can be registered twice (one copy disabled): use the enabled one
let target = targets.first(where: isEnabled) ?? targets[0]
if !isEnabled(target) {
  TISEnableInputSource(target)
}
let current = TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()
if id(current) != layoutID && TISSelectInputSource(target) != noErr {
  print("Couldn't select ABC – Romanian")
  exit(1)
}

for source in layouts where id(source) != layoutID && isEnabled(source) {
  TISDisableInputSource(source)
}
