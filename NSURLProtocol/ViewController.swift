//
//  ViewController.swift
//  NSURLProtocol
//
//  Created by Jacue on 2020/5/12.
//  Copyright © 2020 Jacue. All rights reserved.
//

import UIKit

let cellTitles = ["NSURLConnection", "NSURLSession", "UIWebView", "WKWebView", "React Native", "Flutter"]

class ViewController: UIViewController {
    
    var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "URLProtocol"
        
        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = cellTitles[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row == 2) {
            let wkWebViewController = UIWebViewController()
            self.navigationController?.pushViewController(wkWebViewController, animated: true)
        } else if (indexPath.row == 3) {
            let wkWebViewController = WKWebViewController()
            self.navigationController?.pushViewController(wkWebViewController, animated: true)
        }
    }
}
