//
//  BrowserView.swift
//  WebViewProject
//
//  Original Code by Karin Prater on 16.05.23.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif
struct BrowserView: View {
    @StateObject var browserViewModel = BrowserViewModel()
    @State private var hideURLbar = false
    @State private var shakeOptions = false
    @State private var showSettings = false
    @AppStorage("Save-Last-URL") var saveLastURL = false
    @AppStorage("Movable URL-Bar") var urlBarMovable = false
    @AppStorage("Quick Position Reset Overlay") var quickPositionReset = false
    @AppStorage("Default-URL") var DefaultURL = ""
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("Shakeable") var shakeable = true
    @AppStorage("OFFSET_X") var offsetX: Double = 0
    @AppStorage("OFFSET_Y") var offsetY: Double = 0
    
    var offset: CGSize {
        CGSize(width: offsetX, height: offsetY)
    }
    var customColor: Color {
        colorScheme == .dark ? .white : .black
    }
    var body: some View {
        ZStack {
            if let url =  URL(string: browserViewModel.urlString) {
                BrowserWebView(url: url,
                               viewModel: browserViewModel)
                .edgesIgnoringSafeArea(.all)
#if os(iOS)
                .padding(.top, 1)
#endif
            } else {
                NewTabPage()
            }
            VStack {
                if urlBarMovable {
                    if quickPositionReset {
                        if offset == CGSize(width: 0, height: 0) {}
                        else {
                            VStack {
                                Image(systemName: "dot.scope")
                                    .onTapGesture {
                                        offsetX = 0
                                        offsetY = 0
                                    }
                                    .buttonStyle(.plain)
                                    .background(
                                        RoundedRectangle(cornerRadius: 100)
                                            .foregroundStyle(.thinMaterial)
                                            .frame(width: 30, height: 30)
                                        
                                    )
                            }
#if os(iOS)
                            .padding(10)
#endif
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                        }
                    }
                }
                if hideURLbar {
                    VStack {
                        Image(systemName: "eye.fill")
                            .onTapGesture {
                                hideURLbar = false
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .foregroundStyle(.thinMaterial)
                                    .frame(width: 30, height: 30)
                                
                            )
                    }
#if os(iOS)
                    .padding(25)
#elseif os(macOS)
                    .padding(10)
#endif
                }
                else {
                    VStack {
                        HStack {
                            Spacer(minLength: 15)
                            
                            Button(action: {
                                browserViewModel.goBack()
                            }) {
                                Image(systemName: "chevron.left")
#if os(iOS)
                                    .font(.system(size: 24, weight: .medium))
#elseif os(macOS)
                                    .font(.system(size: 16, weight: .medium))
#endif
                                    .foregroundStyle(.primary)
                            }
                            .disabled(!browserViewModel.canGoBack)
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                browserViewModel.goForward()
                            }) {
                                Image(systemName: "chevron.right")
#if os(iOS)
                                    .font(.system(size: 24, weight: .medium))
#elseif os(macOS)
                                    .font(.system(size: 16, weight: .medium))
#endif
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                            .disabled(!browserViewModel.canGoForward)
                            
                            .padding(.trailing, 5)
                            
                            TextField("Enter a URL or Search Google", text: $browserViewModel.urlString, onCommit: {
                                // Handle URL formatting before calling loadURLString
                                var input = browserViewModel.urlString.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                // Check if the string contains a dot and no spaces (valid domain-like string)
                                if input.contains(".") && !input.contains(" ") {
                                    // If it's a valid domain-like string and doesn't already contain a protocol, add "http://"
                                    if !input.contains("://") {
                                        input = "http://\(input)"
                                    }
                                } else {
                                    // If the string doesn't contain a dot or contains spaces, treat it as a search query
                                    let query = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? input
                                    input = "https://www.google.com/search?q=\(query)"
                                }
                                
                                // Update the URL string in the view model
                                browserViewModel.urlString = input
                                
                                // Call the function to load the formatted URL
                                browserViewModel.loadURLString()
                            })
                            .disableAutocorrection(true)
                            .textFieldStyle(.plain)
#if os(iOS)
                            .autocapitalization(.none)
#endif
                            
#if os(macOS)
                            Button(action: {
                                browserViewModel.reload()
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                            Button(action: {
                                hideURLbar = true
                            }) {
                                Image(systemName: "eye.slash.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                            Button(action: {
                                if browserViewModel.urlString == "" {
                                    let urlToShare = URL(string: "https://github.com/timi2506/Browser")
                                    let sharingPicker = NSSharingServicePicker(items: [urlToShare])
                                    
                                    // Get the current window and anchor the picker to it
                                    if let window = NSApplication.shared.windows.first {
                                        sharingPicker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                                    }
                                }
                                else {
                                    let urlToShare = URL(string: browserViewModel.urlString)
                                    let sharingPicker = NSSharingServicePicker(items: [urlToShare])
                                    
                                    // Get the current window and anchor the picker to it
                                    if let window = NSApplication.shared.windows.first {
                                        sharingPicker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
                                    }
                                }
                                
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
#elseif os(iOS)
                            Menu(content: {
                                Button(action: {
                                    browserViewModel.reload()
                                }) {
                                    HStack {
                                        Text("Reload")
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundStyle(.primary)
                                    }
                                }
                                .buttonStyle(.plain)
                                Button(action: {
                                    hideURLbar = true
                                }) {
                                    HStack {
                                        Text("Hide URL Bar")
                                        Image(systemName: "eye.slash.fill")
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundStyle(.primary)
                                    }
                                }
                                .buttonStyle(.plain)
                                Button("Settings", systemImage: "gear") {
                                    showSettings = true
                                }
                                Button("Share URL", systemImage: "square.and.arrow.up") {
                                    if browserViewModel.urlString == "" {
                                        let url = URL(string: "https://github.com/timi2506/Browser")
                                        let activityView = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                                        
                                        let allScenes = UIApplication.shared.connectedScenes
                                        let scene = allScenes.first { $0.activationState == .foregroundActive }
                                        
                                        if let windowScene = scene as? UIWindowScene {
                                            windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
                                        }
                                        
                                    }
                                    else {
                                        let url = URL(string: browserViewModel.urlString)
                                        let activityView = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
                                        
                                        let allScenes = UIApplication.shared.connectedScenes
                                        let scene = allScenes.first { $0.activationState == .foregroundActive }
                                        
                                        if let windowScene = scene as? UIWindowScene {
                                            windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "ellipsis.circle.fill")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(customColor)
                            }
                            
#endif
                            Spacer(minLength: 15)
                        }
                        
                        
                        
#if os(iOS)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.thinMaterial)
                                .frame(height: 50)
                            
                        )
#elseif os(macOS)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.thinMaterial)
                                .frame(height: 50)
                                .shadow(color: .primary.opacity(0.1), radius: 5)
                        )
#endif
                        .padding(10)
                    }
                    
                    .offset(offset)
                    // Attach drag gesture
                    .gesture(
                        urlBarMovable ? DragGesture()
                            .onChanged { gesture in
                                offsetX = gesture.translation.width
                                offsetY = gesture.translation.height
                            }
                        : nil // No gesture when dragging is disabled
                    )
                }
                
            }
#if os(macOS)
            .padding(25)
#endif
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            
        }
        .onChange(of: browserViewModel.urlString) { newURL in
            if saveLastURL {
                DefaultURL = newURL
            }
        }
        #if os(iOS)
        .onShake {
            if shakeable {
                shakeOptions = true
            }
        }
        #endif
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .confirmationDialog("Shake Menu", isPresented: $shakeOptions, titleVisibility: .visible) {
            Button("Open Settings") {
                showSettings = true
            }
            if urlBarMovable {
                Button("Reset the URL-Bar Location") {
                    offsetX = 0
                    offsetY = 0
                }
            }
        }
    }
}
#if os(iOS)
// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}
#endif
