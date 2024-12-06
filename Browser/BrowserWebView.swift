//
//  BrowserWebView.swift
//  WebViewProject
//
//  Original Code by Karin Prater on 16.05.23.
//

import SwiftUI
import WebKit
#if os(iOS)
struct BrowserWebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: BrowserViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        viewModel.webView = webView
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
#elseif os(macOS)
struct BrowserWebView: NSViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: BrowserViewModel

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        viewModel.webView = webView // Assign the WKWebView to the ViewModel
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Optionally handle updates if needed
    }
}
#endif
