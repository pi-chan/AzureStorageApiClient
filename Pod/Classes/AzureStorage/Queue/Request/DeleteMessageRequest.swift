//
//  DeleteMessageRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import Regex

public extension AzureQueue {
    public class DeleteMessageRequest:  Request {
        public let method = "DELETE"
        let queue : String
        let messageId : String
        let popReceipt : String
        
        public typealias Response = Bool
        
        public init(queue : String, messageId: String, popReceipt : String) {
            self.queue = queue
            self.messageId = messageId
            self.popReceipt = popReceipt
        }
        
        public func path() -> String {
            var equalReplacedStr : String = popReceipt.replaceRegex("=", with: "%3D")
            return "/\(queue)/messages/\(messageId)?popreceipt=\(equalReplacedStr)"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return ["Content-Length": "0"]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return []
        }
    }
}
