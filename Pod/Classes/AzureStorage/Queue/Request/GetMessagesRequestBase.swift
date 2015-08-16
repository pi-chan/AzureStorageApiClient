//
//  GetMessagesRequestBase.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class GetMessagesRequestBase:  Request {
        public let method = "GET"
        let queue : String
        let numberOfMessages : Int?
        
        public typealias Response = [Message]
        
        public init(queue : String, numberOfMessages : Int?) {
            self.queue = queue
            self.numberOfMessages = numberOfMessages
        }
        
        public func path() -> String {
            var base = "/\(queue)/messages"
            let params = parameters()
            if params.count == 0 {
                return base
            }
            return base + "?" + join("&", params)
        }
        
        public func body() -> NSData? {
            return nil
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertResponseObject(object: AnyObject?) -> Response? {
            var messages : [Message] = []
            let response = AzureStorage.xmlResponseToDictionary(object)
            if let aDicOrArray: AnyObject = response?.valueForKeyPath("QueueMessage") {
                var dictionaries : [NSDictionary] = []
                if let dics = aDicOrArray as? [NSDictionary] {
                    dictionaries = dics
                } else {
                    dictionaries = [(aDicOrArray as! NSDictionary)]
                }
                
                for dictionary in dictionaries {
                    if let message = Message(dictionary: dictionary) {
                        messages.append(message)
                    }
                }
            }
            return messages
        }
        
        public func responseTypes() -> Set<String>? {
            return ["application/xml"]
        }
        
        internal func parameters() -> [String] {
            if let number = numberOfMessages {
                return ["numofmessages=\(number)"]
            }
            return []
        }
    }
}
