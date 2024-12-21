//
//  BaoKimViewController.swift
//  Shang_Buyer
//
//  Created by Louis Macbook on 29/11/2024.
//

import UIKit
import WebKit

protocol BaoKimViewControllerDelegate: AnyObject {
    func onPaymentComplete()
    func onPaymentFailed()
    func didCloseBaoKim()
}

class BaoKimViewController: UIViewController {
    var delegate: BaoKimViewControllerDelegate?
    var coordinator: CartCoordinator?
    private var url: String
    var webView: WKWebView!

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
        setupNav()
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    private func setupNav() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButton))
        backButton.tintColor = .black
        setupNavigationBar(leftBarButton: backButton, title: "Thanh toán Bảo Kim")
    }

    @objc private func backButton() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.popViewController(animated: false)
        delegate?.didCloseBaoKim()
    }
}

extension BaoKimViewController: WKUIDelegate, WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
//        if let currentURL = webView.url?.absoluteString {
//            if currentURL.contains("https://www.baokim.vn/?created_at=") {
//                navigateToSuccessScreen()
//            }
//        }
//    }

    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            if url.contains("https://www.baokim.vn/?created_at=") {
                navigateToSuccessScreen(isSuccess: true)
                decisionHandler(.cancel)
                return
            }
            if url.contains("https://www.baokim.vn/?id=") {
                navigateToSuccessScreen(isSuccess: false)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    private func navigateToSuccessScreen(isSuccess: Bool) {
        navigationController?.popViewController(animated: false)
        if isSuccess {
            delegate?.onPaymentComplete()
        } else {
            delegate?.onPaymentFailed()
        }
    }
}
