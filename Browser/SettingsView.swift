import SwiftUI

struct SettingsView: View {
    @AppStorage("Default-URL") var DefaultURL = ""
    @AppStorage("Selected NewTab Config") var selectedNewTabConfig = 1
    @AppStorage("new-tab-bg") var ImageURL = ""
    @AppStorage("Use-Image") var useImage = false
    @AppStorage("Save-Last-URL") var saveLastURL = false
    @AppStorage("Movable URL-Bar") var urlBarMovable = false
    @AppStorage("Quick Position Reset Overlay") var quickPositionReset = false
    @State private var useBlurredView = true
    @AppStorage("OFFSET_X") var offsetX: Double = 0
    @AppStorage("OFFSET_Y") var offsetY: Double = 0
    
    var offset: CGSize {
        CGSize(width: offsetX, height: offsetY)
    }
    
    var body: some View {
        TabView {
            VStack {
                List {
                    Section("Default URL") {
                        VStack {
                            TextField("""
                        e.g. "https:/example.com"
                        """, text: $DefaultURL)
                            .disabled(saveLastURL)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)
#if os(iOS)
                            .autocapitalization(.none)
#endif
                            Text("""
                         DON'T FORGET TO PUT THE PREFIX (https:// or http://) IN FRONT OF THE VALUE
                         (Example: "https://google.com" instead of just "google.com")
                         
                         To show the Default New-Tab-Page leave this field blank
                         """)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        VStack {
                            Toggle(isOn: $saveLastURL) {
                                Text("Save Last URL")
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            
                            Text("Toggles if the App should save the URL opened before closing to reopen it after an app restart")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        
                    }
                    Section ("New Tab Page Customization") {
                        Picker ("Background", selection: $selectedNewTabConfig) {
                            Text("Background Image")
                                .tag(0)
                            Text("Blurred Camera View")
                                .tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: selectedNewTabConfig) { newValue in
                            if newValue == 1 {
                                useBlurredView = true
                                useImage = false
                            }
                            if newValue == 0 {
                                useBlurredView = false
                                useImage = true
                            }
                        }
                        Text("NOTE: Blurred Camera View captures live input from your camera and overlays a blur over it, the camera data is not sent to any third partys and is completely handled on-device, to read more about how it works, feel free to look at the Source Code on GitHub")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                    }
                }
            }
            .navigationTitle("General Settings")
            .tabItem {
                HStack {
                    Image(systemName: "gear")
                    Text("General")
                }
            }
            VStack {
                List {
                    Text("Disclaimer: These are experimental options available for users to test, they might be unstable, use at your own risk")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Section("URL-Bar Movement") {
                        VStack {
                            Toggle("Enable URL-Bar Movement", isOn: $urlBarMovable)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Text("Toggle whether the URL-Bar can be dragged to a different position or not")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        
                        VStack {
                            Toggle("Enable Quick Position Reset", isOn: $quickPositionReset)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Text("Toggles showing a small overlay to reset the URL Bar Position in case it ever goes off-screen or has to be quickly reset without opening Settings")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        .disabled(!urlBarMovable)

                        VStack {
                            Button ("Reset URL Bar Offset") {
                                offsetX = 0
                                offsetY = 0
                            }
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            Text("Moves the URL-Bar back to the Default Position")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        .disabled(!urlBarMovable)
                    }
                }
            }
            .navigationTitle("Experimental Settings")
            .tabItem {
                HStack {
                    Image(systemName: "sparkles")
                    Text("Experimental")
                }
            }
        }
    }
}
