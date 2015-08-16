//
//  CreateContainerRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import Foundation

public extension AzureBlob {
    public class CreateContainerRequest:  Request {
        public let method = "PUT"
        let container : String!
        
        public typealias Response = Bool
        
        public init(container: String) {
            self.container = container
        }
        
        public func path() -> String {
            return "/\(container)?restype=container"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return ["Content-Type": "", "Content-Length": "0"]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return []
        }
    }
}
