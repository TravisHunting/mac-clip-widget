//
//  clippyApp.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI
import AppKit

@main
struct clippyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle URL scheme calls from widget
                    if url.scheme == "clippy" && url.host == "screenshot" {
                        // Minimize all app windows before taking screenshot
                        minimizeAppWindows()
                        
                        // Add slight delay to ensure windows are minimized
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            ScreenshotManager.takeScreenshotAndCopyToClipboard()
                        }
                    }
                }
        }
    }
    
    // Function to minimize all app windows
    private func minimizeAppWindows() {
        NSApplication.shared.windows.forEach { window in
            window.miniaturize(nil)
        }
    }
}