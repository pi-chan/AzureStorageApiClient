//
//  CorsRule.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/17/15.
//
//

import Foundation
import XMLDictionary

public extension AzureBlob {
    public class CorsRule {
        public var allowedOrigins : [String] = []
        public var allowedMethods : [String] = []
        public var allowedHeaders : [String] = []
        public var exposedHeaders : [String] = []
        public var maxAgeInSeconds : Int = 600
        
        public init?(allowedOrigins:[String], allowedMethods:[String], allowedHeaders:[String], exposedHeaders:[String], maxAgeInSeconds:Int) {
            self.allowedOrigins = allowedOrigins
            self.allowedMethods = allowedMethods
            self.allowedHeaders = allowedHeaders
            self.exposedHeaders = exposedHeaders
            self.maxAgeInSeconds = maxAgeInSeconds
            
            if allowedOrigins.count == 0 || allowedMethods.count == 0 ||
                allowedHeaders.count == 0 || exposedHeaders.count == 0 ||
                maxAgeInSeconds < 0 {
                return nil
            }
        }
        
        public init(dictionary: NSDictionary) {
            if let alheaders = dictionary.valueForKey("AllowedHeaders") as? String {
                self.allowedHeaders = split(alheaders, allowEmptySlices: false, isSeparator: { $0 == "," })
            }
            if let origins = dictionary.valueForKey("AllowedOrigins") as? String {
                self.allowedOrigins = split(origins, allowEmptySlices: false, isSeparator: { $0 == "," })
            }
            if let methods = dictionary.valueForKey("AllowedMethods") as? String {
                self.allowedMethods = split(methods, allowEmptySlices: false, isSeparator: { $0 == "," })
            }
            if let exheaders = dictionary.valueForKey("ExposedHeaders") as? String {
                self.exposedHeaders = split(exheaders, allowEmptySlices: false, isSeparator: { $0 == "," })
            }
            if let maxAgeStr = dictionary.valueForKey("MaxAgeInSeconds") as? String {
                if let maxAge = maxAgeStr.toInt() {
                    self.maxAgeInSeconds = maxAge
                }
            }
        }
        
        public func toXML() -> String {
            let dictionary = [
                "AllowedOrigins" : join(",", allowedOrigins),
                "AllowedMethods" : join(",", allowedMethods),
                "AllowedHeaders" : join(",", allowedHeaders),
                "ExposedHeaders" : join(",", exposedHeaders),
                "MaxAgeInSeconds" : String(maxAgeInSeconds),
                "__name" : "CorsRule"
            ] as NSDictionary

            return dictionary.XMLString()
        }
    }
}
