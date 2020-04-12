//
//  NeedHelpViewController.swift
//  RemindMe
//
//  Created by Quynh Dinh on 2020-04-12.
//  Copyright © 2020 BBQS. All rights reserved.
//

import UIKit
import WebKit

class NeedHelpViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!
    @IBOutlet var indicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the webview to load the website
        let url = URL(string: "https://www.google.com")
        let request = URLRequest(url: url!)
        
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    // Connect the indicator with webkit view progress
    // When the web starts loaded
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    // The indicator will stop spinning when the web finishes loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}
