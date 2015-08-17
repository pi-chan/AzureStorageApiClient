//
//  DeleteBlobRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public extension AzureBlob {
    public class DeleteBlobRequest: Request {
        public let method = "DELETE"
        let container : String
        let name : String
        
        public typealias Response = Bool
        
        public init(container: String, name: String) {
            self.container = container
            self.name = name
        }
        
        public func path() -> String {
            return "/\(container)/\(name)"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return ["Content-Length":"0"]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return nil
        }
    }
}