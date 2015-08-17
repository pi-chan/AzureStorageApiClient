//
//  SetBlobServiceCorsRequest.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation

public extension AzureBlob {
    public class SetBlobServiceCorsRequest: Request {
        public let method = "PUT"
        let corsRules : [CorsRule]
        
        public typealias Response = Bool
        
        public init(rules : [CorsRule]) {
            corsRules = rules
        }
        
        public func path() -> String {
            return "/?restype=service&comp=properties"
        }
        
        public func body() -> NSData? {
            var rules = join("", corsRules.map { $0.toXML() })
            let xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><StorageServiceProperties><Cors>\(rules)</Cors></StorageServiceProperties>"
            return xml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        }
        
        public func additionalHeaders() -> [String : String] {
            return RequestUtility.headerForXmlBody(body())
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            return true
        }
        
        public func responseTypes() -> Set<String>? {
            return nil
        }
    }
}
