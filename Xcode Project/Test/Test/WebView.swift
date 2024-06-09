import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // No updates needed as the WKWebView is directly controlled by the WebViewModel
    }
}
