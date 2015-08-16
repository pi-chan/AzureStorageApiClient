//
//  ListQueuesRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureBlob {
    public class ListContainersRequest:  Request {
        public let method = "GET"
        
        public typealias Response = [Container]
        
        public init() {
        }
        
        public func path() -> String {
            return "/?comp=list"
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            var containers : [Container] = []
            let response = AzureStorage.xmlResponseToDictionary(object)
            if let aDicOrArray: AnyObject = response?.valueForKeyPath("Containers.Container") {
                var dictionaries : [NSDictionary] = []
                if let dics = aDicOrArray as? [NSDictionary] {
                    dictionaries = dics
                } else {
                    dictionaries = [(aDicOrArray as! NSDictionary)]
                }
                
                for dictionary in dictionaries {
                    if let container = Container(dictionary: dictionary) {
                        containers.append(container)
                    }
                }
            }
            return containers
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
    }
}
