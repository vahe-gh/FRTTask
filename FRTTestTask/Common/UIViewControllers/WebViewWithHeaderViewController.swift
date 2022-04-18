//
//  WebViewWithHeaderViewController.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import UIKit
import WebKit

class WebViewWithHeaderViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: Private
    
    private let progressIndicator = UIActivityIndicatorView()
    private var webView = WKWebView()
    
    // MARK: External
    
    var url : URL?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = barButtonItem
        
        progressIndicator.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        progressIndicator.startAnimating()
        progressIndicator.style = UIActivityIndicatorView.Style.medium
        view.addSubview(progressIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        if let url = url {
//            print("Web View URL : \(url.absoluteString)")
            let urlRequest = URLRequest(url: url)
            webView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            webView.load(urlRequest)
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationItem.setHidesBackButton(false, animated: false)
    }

    // MARK: - User interaction
    
    @objc func dismissVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - WKUIDelegate

extension WebViewWithHeaderViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.addSubview(webView)
        progressIndicator.removeFromSuperview()
    }
    
}
