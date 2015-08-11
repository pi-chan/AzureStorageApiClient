//
//  PutMessageRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class PutMessagesRequest: Request {
        public let method = "POST"
        let queue : String
        var message : String
        var messageTTL : Int?
        var visibilityTimeout : Int?
        
        public typealias Response = Bool
        
        public init(queue : String, message: String, messageTTL: Int?, visibilityTimeout: Int?) {
            self.queue = queue
            self.message = message
            self.messageTTL = messageTTL
            self.visibilityTimeout = visibilityTimeout
        }
        
        public func path() -> String {
            var base = "/\(queue)/messages"
            var params : [String] = []
            if let ttl = messageTTL {
                params.append("messagettl=\(ttl)")
            }
            if let visibility = visibilityTimeout {
                params.append("visibilitytimeout=\(visibility)")
            }
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
    }
}
