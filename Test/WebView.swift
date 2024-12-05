import SwiftUI
import WebKit

struct WebView: View {
    let webView: WKWebView

    var body: some View {
        PlatformWebView(webView: webView)
        #if os(iOS)
            .padding(.top, 50)
        #endif
            .cornerRadius(15)
            .ignoresSafeArea()

    }
}

#if os(macOS)
struct PlatformWebView: NSViewRepresentable {
    let webView: WKWebView

    func makeNSView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // No updates needed as the WKWebView is directly controlled by the WebViewModel
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                // Save the URL to UserDefaults
                UserDefaults.standard.set(url.absoluteString, forKey: "URL")
            }
        }
    }
}
#elseif os(iOS)
struct PlatformWebView: UIViewRepresentable {
    let webView: WKWebView

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator // Set the navigation delegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed as the WKWebView is directly controlled by the WebViewModel
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url {
                // Save the URL to UserDefaults
                UserDefaults.standard.set(url.absoluteString, forKey: "URL")
            }
        }
    }
}
#endif
