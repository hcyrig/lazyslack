//
//  MainWindowController.swift
//

import Foundation

import AppKit

import NOFoundation

final class MainWindowController: NSWindowController {
  
  override func windowDidLoad() {
    
    applyWindowControllerRestorationName("lazyslack-window-controller")
    
    super.windowDidLoad()
  }
}
