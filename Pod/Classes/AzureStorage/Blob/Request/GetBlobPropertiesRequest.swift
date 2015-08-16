//
//  GetBlobPropertiesRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/16/15.
//
//

import Foundation

public extension AzureBlob {
    public class GetBlobPropertiesRequest: Request {
        public let method = "HEAD"
        let container : String
        let name : String
        
        public typealias Response = [NSObject: AnyObject]
        
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
            return [:]// ["If-Modified-Since":"", "If-None-Match": ""]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return object as? Response
        }
        
        public func responseTypes() -> Set<String>? {
            return nil
        }
    }
    
}
