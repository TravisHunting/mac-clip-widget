//
//  ScreenshotManager.swift
//  clippy
//
//  Created by Travis on 02/04/2025.
//

import SwiftUI
import AppKit
import ScreenCaptureKit

struct ScreenshotManager {
    static func takeScreenshotAndCopyToClipboard() {
        Task {
            do {
                let streamConfig = SCStreamConfiguration()
                let display = try await SCShareableContent.current.displays.first
                guard let display else {
                    print("No display found")
                    return
                }

                let filter = SCContentFilter(display: display, excludingWindows: [])
                let stream = SCStream(filter: filter, configuration: streamConfig, delegate: nil)
                try await stream.startCapture()

                class CustomStreamOutput: NSObject, SCStreamOutput {
                    var onNewSampleBuffer: ((CMSampleBuffer) -> Void)?

                    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
                        onNewSampleBuffer?(sampleBuffer)
                    }
                }

                let output = CustomStreamOutput()
                output.onNewSampleBuffer = { sampleBuffer in
                    guard let pixelBuffer = sampleBuffer.imageBuffer else {
                        print("Failed to capture frame")
                        return
                    }

                    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                    let context = CIContext()
                    guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
                        print("Failed to create CGImage")
                        return
                    }

                    let nsImage = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setData(nsImage.tiffRepresentation, forType: .tiff)
                    print("Screenshot taken and copied to clipboard!")
                }

                do {
                    try stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: DispatchQueue.main)
                } catch {
                    print("Failed to add stream output: \(error)")
                }

                try await Task.sleep(nanoseconds: 1_000_000_000) // Allow time for frame capture
                try await stream.stopCapture()

            } catch {
                print("Error capturing screenshot: \(error)")
            }
        }
    }
}
