import SwiftUI
import WebKit

struct ContentView: View {
    @State private var tabs: [TabModel] = [TabModel(urlString: "https://timi2506.github.io")]
    @State private var selectedTabIndex: Int = 0
    @State private var popover = false
    @AppStorage("firstLaunch") var wasLaunchedBefore = false
    @State private var tabHelpAlert = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTabIndex) {
                ForEach(tabs.indices, id: \.self) { index in
                    WebView(webView: tabs[index].webViewModel.webView)
                        .tabItem {
                            Text(tabs[index].urlString)
                        }
                        .tag(index)
                }
            }
            .ignoresSafeArea()

#if os(iOS)
            .tabViewStyle(.page)
#endif
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    Spacer(minLength: 15)
                    Button(action: {
                        tabs[selectedTabIndex].webViewModel.goBack()
                    }) {
                        Image(systemName: "chevron.left")
#if os(iOS)
                            .font(.system(size: 24, weight: .medium))
#elseif os(macOS)
                            .font(.system(size: 16, weight: .medium))
#endif
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                    .disabled(!tabs[selectedTabIndex].webViewModel.canGoBack)

                    Button(action: {
                        tabs[selectedTabIndex].webViewModel.goForward()
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
                    .disabled(!tabs[selectedTabIndex].webViewModel.canGoForward)

                    Spacer()

                    TextField("Enter URL", text: $tabs[selectedTabIndex].webViewModel.currentURL, onCommit: {
                        tabs[selectedTabIndex].webViewModel.load(urlString: tabs[selectedTabIndex].webViewModel.currentURL)
                    })
                    .textFieldStyle(.plain)
                    .padding()

                    Spacer()

#if os(iOS)
                    Menu {
                        Button(action: addTab) {
                            Image(systemName: "plus")
                            Text("Add Tab")
                        }
                        .buttonStyle(.plain)

                        Button(action: closeTab) {
                            Image(systemName: "xmark")
                            Text("Close Current Tab")
                        }
                        .disabled(tabs.count <= 1)
                        .buttonStyle(.plain)

                        Button(action: {
                            if let savedURLString = UserDefaults.standard.string(forKey: "URL"),
                               let savedURL = URL(string: savedURLString) {
                                tabs[selectedTabIndex].webViewModel.load(urlString: savedURL.absoluteString)
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                            Text("Reload Current Tab")
                        }
                        .buttonStyle(.plain)
                    } label: {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)

#elseif os(macOS)
                    Button(action: {
                        popover = true
                    }) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
#endif
                    Spacer()
                }
                .popover(isPresented: $popover) {
                    Form {
                        Button(action: addTab) {
                            Image(systemName: "plus")
                            Text("Add Tab")
                        }
                        .buttonStyle(.plain)

                        Divider()

                        Button(action: closeTab) {
                            Image(systemName: "xmark")
                            Text("Close Current Tab")
                        }
                        .disabled(tabs.count <= 1)
                        .buttonStyle(.plain)

                        Divider()

                        Button(action: {
                            if let savedURLString = UserDefaults.standard.string(forKey: "URL"),
                               let savedURL = URL(string: savedURLString) {
                                tabs[selectedTabIndex].webViewModel.load(urlString: savedURL.absoluteString)
                            }
                        }) {
                            Image(systemName: "arrow.clockwise")
                            Text("Reload Current Tab")
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                }

#if os(iOS)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.thinMaterial)
                )
#elseif os(macOS)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(.thinMaterial)
                )
#endif
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .alert(isPresented: $tabHelpAlert) {
            Alert(
                title: Text("Tip"),
                message: Text("To switch between Tabs just swipe left or right!"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }

    private func addTab() {
        if !wasLaunchedBefore {
            #if os(iOS)
            tabHelpAlert = true
            #endif
            wasLaunchedBefore = true
        }
        let newTab = TabModel(urlString: "https://timi2506.github.io")
        tabs.append(newTab)
        selectedTabIndex = tabs.count - 1
    }

    private func closeTab() {
        if tabs.count > 1 {
            tabs.remove(at: selectedTabIndex)
            selectedTabIndex = min(selectedTabIndex, tabs.count - 1)
        }
    }
}
