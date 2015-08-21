//
//  PutBlobRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import Foundation

public extension AzureBlob {
    class PutBlobRequest: Request {
        public let method = "PUT"
        let container : String
        let name : String
        let data : NSData
        let mimetype : String
        
        public typealias Response = Bool
        
        public init(container: String, name: String, data: NSData, mimetype: String?) {
            self.container = container
            self.name = name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            self.data = data
            if let type = mimetype {
                self.mimetype = type
            } else {
                self.mimetype = ""
            }
        }
        
        public func path() -> String {
            return "/\(container)/\(name)"
        }
        
        public func body() -> NSData? {
            return data
        }
        
        public func additionalHeaders() -> [String : String] {
            let length = data.length
            return ["Content-Length": "\(length)", "Content-Type": mimetype, "x-ms-blob-type": "BlockBlob"]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return nil
        }
    }
}
