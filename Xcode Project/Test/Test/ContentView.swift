import SwiftUI
import WebKit

struct ContentView: View {
    @State private var tabs: [TabModel] = [TabModel(urlString: "https://www.apple.com")]
    @State private var selectedTabIndex: Int = 0

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    tabs[selectedTabIndex].webViewModel.goBack()
                }) {
                    Image(systemName: "arrow.left")
                }
                .disabled(!tabs[selectedTabIndex].webViewModel.canGoBack)

                TextField("Enter URL", text: $tabs[selectedTabIndex].urlString, onCommit: {
                    tabs[selectedTabIndex].webViewModel.load(urlString: tabs[selectedTabIndex].urlString)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Button(action: {
                    tabs[selectedTabIndex].webViewModel.goForward()
                }) {
                    Image(systemName: "arrow.right")
                }
                .disabled(!tabs[selectedTabIndex].webViewModel.canGoForward)

                Button(action: addTab) {
                    Image(systemName: "plus")
                }

                Button(action: closeTab) {
                    Image(systemName: "minus")
                }
                .disabled(tabs.count <= 1)
            }
            .padding()

            TabView(selection: $selectedTabIndex) {
                ForEach(tabs.indices, id: \.self) { index in
                    WebView(webView: tabs[index].webViewModel.webView)
                        .tabItem {
                            Text(tabs[index].urlString)
                        }
                        .tag(index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func addTab() {
        let newTab = TabModel(urlString: "https://www.apple.com")
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
