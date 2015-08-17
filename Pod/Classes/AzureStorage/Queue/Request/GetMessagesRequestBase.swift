//
//  GetMessagesRequestBase.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class GetMessagesRequestBase:  Request {
        public let method = "GET"
        let queue : String
        let numberOfMessages : Int?
        
        public typealias Response = Collection<Message>
        
        public init(queue : String, numberOfMessages : Int?) {
            self.queue = queue
            self.numberOfMessages = numberOfMessages
        }
        
        public func path() -> String {
            var base = "/\(queue)/messages"
            let params = parameters()
            if params.count == 0 {
                return base
            }
            return base + "?" + join("&", params)
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return ResponseUtility.responseItems(object, keyPath: "QueueMessage")
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
        
        internal func parameters() -> [String] {
            if let number = numberOfMessages {
                return ["numofmessages=\(number)"]
            }
            return []
        }
    }
}
