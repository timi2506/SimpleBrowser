import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    let webView = WKWebView()
    @Published var canGoBack = false
    @Published var canGoForward = false

    private var canGoBackObserver: NSKeyValueObservation?
    private var canGoForwardObserver: NSKeyValueObservation?

    init() {
        canGoBackObserver = webView.observe(\.canGoBack, options: [.new]) { _, change in
            if let newValue = change.newValue {
                DispatchQueue.main.async {
                    self.canGoBack = newValue
                }
            }
        }

        canGoForwardObserver = webView.observe(\.canGoForward, options: [.new]) { _, change in
            if let newValue = change.newValue {
                DispatchQueue.main.async {
                    self.canGoForward = newValue
                }
            }
        }
    }

    func load(urlString: String) {
        let formattedUrlString = formatUrlString(urlString)
        if let url = URL(string: formattedUrlString) {
            webView.load(URLRequest(url: url))
        }
    }

    func goBack() {
        webView.goBack()
    }

    func goForward() {
        webView.goForward()
    }

    private func formatUrlString(_ urlString: String) -> String {
        var formattedUrlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if it contains "https://", "http://", "www." or a period.
        if !formattedUrlString.hasPrefix("http://") &&
            !formattedUrlString.hasPrefix("https://") &&
            !formattedUrlString.contains("www.") &&
            !formattedUrlString.contains(".") {
            // If not, treat it as a search query.
            formattedUrlString = "https://google.com/search?q=\(formattedUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        } else {
            // Add "https://" if it's missing
            if !formattedUrlString.hasPrefix("http://") && !formattedUrlString.hasPrefix("https://") {
                formattedUrlString = "https://" + formattedUrlString
            }

            // Add "www." if it's missing and not a local or IP address
            if formattedUrlString.hasPrefix("https://") || formattedUrlString.hasPrefix("http://") {
                let urlWithoutScheme = formattedUrlString.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "http://", with: "")
                if !urlWithoutScheme.contains("www.") && !urlWithoutScheme.contains(":") && !urlWithoutScheme.contains(".") {
                    formattedUrlString = formattedUrlString.replacingOccurrences(of: "https://", with: "https://www.")
                }
            }
        }

        return formattedUrlString
    }
}
