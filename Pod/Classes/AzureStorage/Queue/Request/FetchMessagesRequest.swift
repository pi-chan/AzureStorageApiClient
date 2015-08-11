//
//  FetchMessageRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class FetchMessagesRequest: Request {
        public let method = "GET"
        let queue : String
        let numberOfMessages : Int?
        
        public typealias Response = [AzureStorage.QueueMessage]
        
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
        
        func parameters() -> [String] {
            if let number = numberOfMessages {
                return ["numofmessages=\(number)"]
            }
            return []
        }
        
        public func body() -> String {
            return ""
        }
        
        public func additionalHeaders() -> [String : String] {
            return [:]
        }
        
        public func convertJSONObject(object: AnyObject?) -> Response? {
            var messages : [AzureStorage.QueueMessage] = []
            let response = object as? NSDictionary
            if let aDicOrArray: AnyObject = response?.valueForKeyPath("QueueMessage") {
                var dictionaries : [NSDictionary] = []
                if let dics = aDicOrArray as? [NSDictionary] {
                    dictionaries = dics
                } else {
                    dictionaries = [(aDicOrArray as! NSDictionary)]
                }
                
                for dictionary in dictionaries {
                    if let message = AzureStorage.QueueMessage(dictionary: dictionary) {
                        messages.append(message)
                    }
                }
            }
            return messages
        }
    }
}
