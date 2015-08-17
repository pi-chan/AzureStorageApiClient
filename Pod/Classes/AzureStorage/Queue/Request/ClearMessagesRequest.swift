//
//  ClearMessagesRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class ClearMessagesRequest:  Request {
        public let method = "DELETE"
        let queue : String
        
        public typealias Response = Bool
        
        public init(queue : String) {
            self.queue = queue
        }
        
        public func path() -> String {
            return "/\(queue)/messages"
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
            return nil
        }
    }
}
