//
//  clippyApp.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI

@main
struct clippyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle URL scheme calls from widget
                    if url.scheme == "clippy" && url.host == "screenshot" {
                        ScreenshotManager.takeScreenshotAndCopyToClipboard()
                    }
                }
        }
    }
}
