//
//  clippyApp.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI
import AppKit

// Forward declare main app entry point for Swift UI
@main
struct clippyApp: App {
    // Use AppDelegate to configure window transparency at app startup
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Window transparency configuration
    init() {
        // Configure window appearance for entire app
        NSWindow.allowsAutomaticWindowTabbing = false
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    // Handle URL scheme calls from widget
                    if url.scheme == "clippy" && url.host == "screenshot" {
                        // Add slight delay before taking screenshot
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            ScreenshotManager.takeScreenshotAndCopyToClipboard()
                        }
                    }
                }
                .background(.clear)
                .edgesIgnoringSafeArea(.all)
                .hidden() // Hide all content
                .background(TransparentWindowHelper())
        }
    }
    
    // Internal screenshot function that doesn't rely on external references
//    private func takeScreenshotAndCopyToClipboard() {
//        Task {
//            do {
//                // Use the ScreenCaptureKit code directly here
//                let scm = try ScreenshotManager()
//                try await scm.captureScreen()
//            } catch {
//                print("Error capturing screenshot: \(error)")
//            }
//        }
//    }
}

// Helper struct to make window transparent
struct TransparentWindowHelper: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.backgroundColor = .clear
                window.isOpaque = false
                window.hasShadow = false
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.level = .floating
                window.ignoresMouseEvents = true
                window.setFrame(NSRect(x: 0, y: 0, width: 1, height: 1), display: false)
                
                // Make the window completely non-activatable
                window.styleMask.insert(.nonactivatingPanel)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

// Helper class to manage screenshots
//class ScreenshotManager {
//    func captureScreen() async throws {
//        // Implementation omitted for brevity - this will call the original implementation
//    }
//}

// App delegate to configure global settings
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Make sure no windows appear in the Dock
        if let window = NSApplication.shared.windows.first {
            window.collectionBehavior = [.stationary, .ignoresCycle]
        }
    }
    
    // Handle reopening app when icon clicked
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Return false to prevent standard behavior
        return false
    }
}
