import SwiftUI

struct SettingsView: View {
    @AppStorage("Default-URL") var DefaultURL = ""
    @AppStorage("new-tab-bg") var ImageURL = ""
    @AppStorage("Use-Image") var useImage = false
    @AppStorage("Save-Last-URL") var saveLastURL = false
    @State private var useBlurredView = true

    var body: some View {
        TabView {
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    VStack {
                        Toggle(isOn: $saveLastURL) {
                            Text("Save Last URL")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        
                        Text("Toggles if the App should save the URL opened before closing to reopen it after an app restart")
                            .font(.caption)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    
                }
                Section ("New Tab Page Customization") {
                    Toggle("Use Background Image",isOn: $useImage)
                        .onChange(of: useImage) {
                            useBlurredView = !useImage
                        }
                    Toggle("Use Blurred Camera View",isOn: $useBlurredView)
                        .onChange(of: useBlurredView) {
                            useImage = !useBlurredView
                        }
                        .onAppear {
                            useBlurredView = !useImage
                        }
                }
            }
            .tabItem {
                HStack {
                    Image(systemName: "gear")
                    Text("General")
                }
            }
            List {
                VStack {
                    Text("Nothing to see here! (yet...)")
                }
            }
            .tabItem {
                HStack {
                    Image(systemName: "questionmark")
                    Text("More")
                }
            }
        }
    }
}
