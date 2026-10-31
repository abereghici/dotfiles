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

let targets = keyboardLayouts().filter { id($0) == layoutID }
guard !targets.isEmpty else {
  print("ABC – Romanian isn't registered yet: log out and back in, then run setup/symlinks.sh again")
  exit(1)
}

for source in targets {
  TISEnableInputSource(source)
}
guard TISSelectInputSource(targets[0]) == noErr else {
  print("Couldn't select ABC – Romanian")
  exit(1)
}

for source in keyboardLayouts() where id(source) != layoutID {
  if property(source, kTISPropertyInputSourceIsEnabled) as? Bool == true {
    TISDisableInputSource(source)
  }
}
