//
//  ViewController.swift
//  WKWebViewDemo
//
//  Created by Jacue on 2018/8/2.
//  Copyright © 2018年 Jacue. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "WKWebView"
        self.setUpWKwebView()
    }
    
    fileprivate func setUpWKwebView() {
        let webConfiguration = WKWebViewConfiguration()
        let myURL = URL(string: "https://www.apple.com.cn")
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        let myRequest = URLRequest(url: myURL!)
        webView?.load(myRequest)
        view.addSubview(webView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension WKWebViewController: WKUIDelegate, WKNavigationDelegate {
    //页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    //当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    //页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

