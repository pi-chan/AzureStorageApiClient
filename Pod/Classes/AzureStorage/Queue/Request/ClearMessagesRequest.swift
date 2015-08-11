//
//  ClearMessagesRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class ClearMessagesRequest: Request {
        public let method = "DELETE"
        let queue : String
        
        public typealias Response = Bool
        
        public init(queue : String) {
            self.queue = queue
        }
        
        public func path() -> String {
            return "/\(queue)/messages"
        }
        
        public func body() -> String {
            return ""
        }
        
        public func additionalHeaders() -> [String : String] {
            return ["Content-Length": "0"]
        }
        
        public func convertJSONObject(object: AnyObject?) -> Response? {
            return true
        }
    }
}
