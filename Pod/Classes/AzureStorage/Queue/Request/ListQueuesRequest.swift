//
//  ListQueuesRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class ListQueuesRequest: Request {
        public let method = "GET"
        
        public typealias Response = [AzureStorage.Queue]
        
        public init() {
        }
        
        public func path() -> String {
            return "/?comp=list&include=metadata"
        }
        
        public func body() -> String {
            return ""
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertJSONObject(object: AnyObject?) -> Response? {
            var queues : [AzureStorage.Queue] = []
            let response = object as? NSDictionary
            if let aDicOrArray: AnyObject = response?.valueForKeyPath("Queues.Queue") {
                var dictionaries : [NSDictionary] = []
                if let dics = aDicOrArray as? [NSDictionary] {
                    dictionaries = dics
                } else {
                    dictionaries = [(aDicOrArray as! NSDictionary)]
                }
                
                for dictionary in dictionaries {
                    if let queue = AzureStorage.Queue(dictionary: dictionary) {
                        queues.append(queue)
                    }
                }
            }
            return queues
        }
    }
}
