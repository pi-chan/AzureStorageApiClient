//
//  PutMessagesRequestBase.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class PutMessagesRequestBase:  Request {
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
            return RequestUtility.headerForXmlBody(body())
        }
        
        public func body() -> NSData? {
            let data : NSData = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
            let encoded = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            let bodyString = "<?xml version=\"1.0\"?>\n<QueueMessage>\n  <MessageText>\(encoded)\n</MessageText>\n</QueueMessage>\n"
            return bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return [""]
        }
        
        internal func parameters() -> [String] {
            return []
        }
        
        internal func basePath() -> String {
            return ""
        }
    }
}
