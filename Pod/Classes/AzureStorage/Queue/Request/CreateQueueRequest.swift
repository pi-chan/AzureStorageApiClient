//
//  CreateQueueRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/07.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class CreateQueueRequest: Request {
        public let method = "PUT"
        let queue : String

        public typealias Response = Bool
        
        public init(queue : String) {
            self.queue = queue
        }
        
        public func path() -> String {
            return "/\(queue)"
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
