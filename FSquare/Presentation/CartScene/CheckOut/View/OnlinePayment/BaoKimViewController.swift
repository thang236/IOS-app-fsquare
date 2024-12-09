//
//  BaoKimViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 29/11/2024.
//

import UIKit
import WebKit

class BaoKimViewController: UIViewController {
    var coordinator: CartCoordinator?
    private var url: String
    var webView: WKWebView!
    var onPaymentComplete: (() -> Void)?

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.defaultWebpagePreferences = prefs
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

extension BaoKimViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
        if let currentURL = webView.url?.absoluteString {
            if currentURL.contains("https://www.baokim.vn/?created_at=") {
                navigateToSuccessScreen()
            }
        }
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    private func navigateToSuccessScreen() {
        navigationController?.popViewController(animated: false)
        onPaymentComplete?()
    }
}
