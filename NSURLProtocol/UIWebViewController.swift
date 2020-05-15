//
//  UIWebViewController.swift
//  NSURLProtocol
//
//  Created by Jacue on 2020/5/12.
//  Copyright © 2020 Jacue. All rights reserved.
//

import UIKit

class UIWebViewController: UIViewController, UISearchBarDelegate {

    var webView: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "UIWebView"
        self.setUpUIWebView()
    }
    
    fileprivate func setUpUIWebView() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        let searchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.size.width, height: 60))
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        webView = UIWebView(frame: CGRect.init(x: 0, y: 60, width: view.bounds.size.width, height: view.bounds.size.height - 60))
        view.addSubview(webView!)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchText = searchBar.text
        let searchUrl = URL(string: searchText!)
        let searchRequest = URLRequest(url: searchUrl!)
        webView?.loadRequest(searchRequest)
    }

}
