//
//  BrowserApp.swift
//  Browser
//
//  Created by timi2506 on 06.12.2024.
//

import SwiftUI

@main
struct BrowserApp: App {
    var body: some Scene {
        WindowGroup {
            BrowserView()
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}
