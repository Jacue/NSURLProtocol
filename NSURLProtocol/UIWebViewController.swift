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
        webView = UIWebView(frame: view.bounds)
        let myURL = URL(string: "https://www.baidu.com")
        let myRequest = URLRequest(url: myURL!)
        webView?.loadRequest(myRequest)
        view.addSubview(webView!)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
