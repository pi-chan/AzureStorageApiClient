//
//  Request.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public protocol Request {
    var method: String { get }
    
    typealias Response: Any
    
    func path() -> String
    func additionalHeaders() -> [String:String]
    func body() -> NSData?
    func convertResponseObject(object: AnyObject?) -> Response?
    func responseTypes() -> Set<String>?
}

public class RequestUtility {
    class func headerForXmlBody(xml: NSData?) -> [String : String] {
        var headers = ["Content-Type": "application/atom+xml; charset=utf-8", "Content-Encoding": "UTF-8"]
        if let data = xml {
            headers["Content-Length"] = "\(data.length)"
            var md5data = data.md5()
            if let md5 = md5data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) {
                headers["Content-Md5"] = md5
            }
        }
        return headers
    }
}