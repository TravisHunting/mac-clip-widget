//
//  ContentView.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI
import AppKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .hidden() // Hide the content
        .background(VisualEffectView(material: .menu, blendingMode: .behindWindow))
        .background(WindowAccessor())
    }
}

// NSVisualEffectView wrapper for transparent background
struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.isEmphasized = false
        view.alphaValue = 0 // Make completely transparent
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// Access and configure the window
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.backgroundColor = .clear
                window.isOpaque = false
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                window.level = .floating // Keep window above others
                window.ignoresMouseEvents = true // Window doesn't respond to clicks
                window.setFrame(NSRect(x: 0, y: 0, width: 0, height: 0), display: false) // Make it tiny
                
                // Make window non-activating
                let windowNumber = window.windowNumber
                NSWindow.allowsAutomaticWindowTabbing = false // Fixed method
                CGSSetWindowLevel(CGSMainConnectionID(), CGSWindowID(windowNumber), CGWindowLevelForKey(.floatingWindow))
                CGSSetWindowTags(CGSMainConnectionID(), CGSWindowID(windowNumber), [2], 32)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

// Private CGS API access
private func CGSMainConnectionID() -> CGSConnectionID {
    return CGSMainConnectionID_()
}

private typealias CGSConnectionID = UInt32
private typealias CGSWindowID = UInt32
@_silgen_name("CGSMainConnectionID") private func CGSMainConnectionID_() -> CGSConnectionID
@_silgen_name("CGSSetWindowLevel") private func CGSSetWindowLevel(_ connection: CGSConnectionID, _ windowID: CGSWindowID, _ level: CGWindowLevel) -> Void
@_silgen_name("CGSSetWindowTags") private func CGSSetWindowTags(_ connection: CGSConnectionID, _ windowID: CGSWindowID, _ tags: [Int], _ count: Int) -> Void

#Preview {
    ContentView()
}
