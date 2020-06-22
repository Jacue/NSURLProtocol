//
//  UIWebViewController.swift
//  NSURLProtocol
//
//  Created by Jacue on 2020/5/12.
//  Copyright © 2020 Jacue. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController {

    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "UIWebView"
        self.setUpUIWebView()
    }
    
    fileprivate func setUpUIWebView() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        webView = UIWebView(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height - 60))
        webView?.delegate = self
        let url = NSURL(string:"https://www.baidu.com")
        let request = NSURLRequest(url: url! as URL)
        webView?.loadRequest(request as URLRequest)

        view.addSubview(webView!)
    }

}

extension UIWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}
