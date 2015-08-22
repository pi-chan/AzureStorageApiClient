//
//  GetBlobServiceCorsRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/21/15.
//
//

import Foundation

public extension AzureBlob {
    public class GetBlobServiceCorsRequest: Request {
        public let method = "GET"
        
        public typealias Response = [CorsRule]
        
        public init() {}
        
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
            return ResponseUtility.dictionaryToDictionaryArray(response?.valueForKeyPath("Cors.CorsRule")).map { CorsRule(dictionary: $0) }
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
    }
}
