//
//  GetBlobRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/14/15.
//
//

import Foundation

public extension AzureBlob {
    public class GetBlobRequest: Request {
        public let method = "GET"
        let container : String
        let name : String
        let mimetype : String
        
        public typealias Response = NSData
        
        public init(container: String, name: String, mimetype: String) {
            self.container = container
            self.name = name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            self.mimetype = mimetype
        }
        
        public func path() -> String {
            return "/\(container)/\(name)"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return ["If-Modified-Since":"", "If-None-Match": ""]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return object as? NSData
        }
        
        public func responseTypes() -> Set<String>? {
            return [mimetype]
        }
    }

}
