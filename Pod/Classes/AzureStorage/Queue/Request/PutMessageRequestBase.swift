//
//  PutMessagesRequestBase.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class PutMessagesRequestBase: Request {
        public var method : String { get { return "" } }
        let queue : String
        var message : String
        
        public typealias Response = Bool
        
        public init(queue : String, message: String) {
            self.queue = queue
            self.message = message
        }
        
        public func path() -> String {
            var base = basePath()
            let params = parameters()
            if params.count == 0 {
                return base
            }
            return base + "?" + join("&", params)
        }
        
        public func additionalHeaders() -> [String:String] {
            var headers : [String:String] = [:]
            headers["Content-Length"] = "\(body().lengthOfBytesUsingEncoding(NSUTF8StringEncoding))"
            headers["Content-Type"] = "application/atom+xml; charset=utf-8"
            headers["Content-Encoding"] = "UTF-8"
            
            var data = body().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            var md5data = data?.md5()
            if let md5 = md5data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) {
                headers["Content-Md5"] = md5
            }
            return headers
        }
        
        public func body() -> String {
            let data : NSData = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            let encoded = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            return "<?xml version=\"1.0\"?>\n<QueueMessage>\n  <MessageText>\(encoded)\n</MessageText>\n</QueueMessage>\n"
        }
        
        public func convertJSONObject(object: AnyObject?) -> Response? {
            return true
        }
        
        internal func parameters() -> [String] {
            return []
        }
        
        internal func basePath() -> String {
            return ""
        }
    }
}
