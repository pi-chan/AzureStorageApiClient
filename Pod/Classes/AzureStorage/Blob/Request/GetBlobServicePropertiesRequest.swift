//
//  GetBlobServicePropertiesRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public extension AzureBlob {
    public class GetBlobServicePropertiesRequest: Request {
        public let method = "GET"

        public typealias Response = NSDictionary
        
        public init() {
        }
        
        public func path() -> String {
            return "/?restype=service&comp=properties"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            let response = ResponseUtility.xmlResponseToDictionary(object)
            return response
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
    }
}
