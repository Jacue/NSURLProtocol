//
//  CustomURLProtocol.swift
//  NSURLProtocol
//
//  Created by Jacue on 2020/5/15.
//  Copyright © 2020 Jacue. All rights reserved.
//

import UIKit

let URLProtocolHandledKey = "URLProtocolHandledKey"

class CustomURLProtocol: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        let handled = URLProtocol.property(forKey: URLProtocolHandledKey, in: request)
        if handled == nil {
            return true
        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    
    override func startLoading() {
        URLProtocol.setProperty(true, forKey: URLProtocolHandledKey, in: self.request as! NSMutableURLRequest)
        let session = URLSession.init(configuration: URLSessionConfiguration(), delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: self.request)
        task.resume()
    }
    
    override func stopLoading() {

    }
}

extension CustomURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.allowed)
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // 下载过程中
        self.client?.urlProtocol(self, didLoad: data)
    }
}


