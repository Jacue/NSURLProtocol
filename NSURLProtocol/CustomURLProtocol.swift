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
        let mutableRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: URLProtocolHandledKey, in: mutableRequest)
        return mutableRequest as URLRequest
    }
        
}
