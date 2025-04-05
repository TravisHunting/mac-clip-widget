//
//  clippyApp.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
    }
    
    // Handle URL scheme outside the UI
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            if url.scheme == "clippy" && url.host == "screenshot" {
                ScreenshotManager.takeScreenshotAndCopyToClipboard()
            }
        }
    }
}

@main
struct clippyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle URL scheme calls from widget
                    if url.scheme == "clippy" && url.host == "screenshot" {
                        ScreenshotManager.takeScreenshotAndCopyToClipboard()
                    }
                }
                .hidden() // Hide the window completely
        }
        .windowStyle(.hiddenTitleBar) // Hide title bar
        .windowResizability(.contentSize) // Prevent window resizing
        .commands {
            // Remove standard menu commands
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            CommandGroup(replacing: .textEditing) {}
            CommandGroup(replacing: .windowList) {}
            CommandGroup(replacing: .windowSize) {}
        }
    }
}
