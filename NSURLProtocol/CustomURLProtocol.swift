//
//  CustomURLProtocol.swift
//  NSURLProtocol
//
//  Created by Jacue on 2020/5/15.
//  Copyright © 2020 Jacue. All rights reserved.
//

import UIKit

let URLProtocolHandledKey = "URLProtocolHandledKey"

class CustomURLProtocolCacheData: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: "CustomURLProtocolCacheData_data")
        coder.encode(response, forKey: "CustomURLProtocolCacheData_response")
        coder.encode(redirectRequest, forKey: "CustomURLProtocolCacheData_redirectRequest")
    }
    
    override init() {
        super.init()
    }


    required init?(coder: NSCoder) {
        super.init()
        data = coder.decodeObject(forKey: "CustomURLProtocolCacheData_data") as? Data
        response = coder.decodeObject(forKey: "CustomURLProtocolCacheData_response") as? URLResponse
        redirectRequest = coder.decodeObject(forKey: "CustomURLProtocolCacheData_redirectRequest") as? URLRequest
    }
    
    var data: Data?
    var response: URLResponse?
    var redirectRequest: URLRequest?
}

class CustomURLProtocol: URLProtocol {
    
    var session: URLSession?
    var downloadTask: URLSessionDataTask?
    var response: URLResponse?
    var cacheData: NSMutableData?
        
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
        if let urlString = self.request.url?.absoluteString {
            if let cacheData = NSKeyedUnarchiver.unarchiveObject(withFile: self._filePathWithUrlString(urlString: urlString)) as? CustomURLProtocolCacheData {
                if let cacheRedirectRequest = cacheData.redirectRequest,
                    let cacheResponse = cacheData.response {
                    self.client?.urlProtocol(self, wasRedirectedTo: cacheRedirectRequest, redirectResponse: cacheResponse)
                } else {
                    if let cacheResponse = cacheData.response,
                        let cacheData = cacheData.data {
                        self.client?.urlProtocol(self, didReceive: cacheResponse, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
                        self.client?.urlProtocol(self, didLoad: cacheData)
                        self.client?.urlProtocolDidFinishLoading(self)
                    }
                }
            } else {
                let request = self.request.mutableCopyWorkaround()
                request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                URLProtocol.setProperty(true, forKey: URLProtocolHandledKey, in: request)
                self.downloadTask = self.session?.dataTask(with: request as URLRequest)
                self.downloadTask?.resume()
            }
        }
    }
    
    override func stopLoading() {
        self.downloadTask?.cancel()
        self.downloadTask = nil
        self.cacheData = nil
        self.response = nil
    }
    
    // MARK: private method
    func _filePathWithUrlString(urlString: String?) -> String {
        if let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last,
            let notNilUrlString = urlString {
            return cachePath + "/" + notNilUrlString
        }
        return ""
    }
    
}

// MARK: URLSession delegate
extension CustomURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        
        // 处理重定向问题
        if let notNilResponse = response as HTTPURLResponse? {
            let redirectRequest = request.mutableCopyWorkaround()
            let cacheData = CustomURLProtocolCacheData()
            cacheData.data = self.cacheData as Data?
            cacheData.response = notNilResponse
            cacheData.redirectRequest = redirectRequest as URLRequest
            
            NSKeyedArchiver.archiveRootObject(cacheData, toFile: self._filePathWithUrlString(urlString: request.url?.absoluteString))
            
            self.client?.urlProtocol(self, wasRedirectedTo: redirectRequest as URLRequest, redirectResponse: notNilResponse)
            completionHandler(request)
        } else {
            completionHandler(request)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        completionHandler(URLSession.ResponseDisposition.allow)
        self.cacheData = NSMutableData()
        self.response = response
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // 下载过程中
        self.client?.urlProtocol(self, didLoad: data)
        self.cacheData?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            let cacheData = CustomURLProtocolCacheData()
            cacheData.data = self.cacheData?.copy() as? Data
            cacheData.response = self.response
            NSKeyedArchiver.archiveRootObject(cacheData, toFile: self._filePathWithUrlString(urlString: request.url?.absoluteString))
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
}



extension URLRequest {
    func mutableCopyWorkaround() -> NSMutableURLRequest {
        let mutableURLRequest = NSMutableURLRequest.init(url: self.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
        for item in self.allHTTPHeaderFields! {
            mutableURLRequest.setValue(item.value, forHTTPHeaderField: item.key)
        }
        if self.httpBodyStream != nil {
            mutableURLRequest.httpBodyStream = self.httpBodyStream
        } else {
            mutableURLRequest.httpBody = self.httpBody
        }
        if  let httpMethod = self.httpMethod {
            mutableURLRequest.httpMethod = httpMethod
        }
        return mutableURLRequest
    }
}
