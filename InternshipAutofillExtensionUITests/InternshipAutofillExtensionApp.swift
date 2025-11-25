//
//  InternshipAutofillExtensionApp.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import SwiftUI

@main
struct InternshipAutofillExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Safari Extension Preferences...") {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.Safari-Settings") {
                        NSWorkspace.shared.open(url)
                    }
                }
                .keyboardShortcut("E", modifiers: [.command, .shift])
            }
            
            CommandGroup(replacing: .help) {
                Button("Workday Autofill Help") {
                    // Open help documentation or website
                    if let url = URL(string: "https://github.com/yourrepo/help") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        }
        
        Settings {
            SettingsView()
                .frame(minWidth: 500, minHeight: 400)
        }
        #endif
    }
}
