//
//  QueueMessage.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/04.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class QueueMessage {
        public let messageId: String!
        public let messageText: String!
        public let dequeueCount: String!
        public let expirationTime: String!
        public let insertionTime: String!
        public let popReceipt: String?
        public let timeNextVisible: String?
        public let rawDictionary : NSMutableDictionary
        
        init?(dictionary: NSDictionary) {
            rawDictionary = NSMutableDictionary(dictionary: dictionary)
            messageId = dictionary["MessageId"] as? String
            dequeueCount = dictionary["DequeueCount"] as? String
            expirationTime = dictionary["ExpirationTime"] as? String
            insertionTime = dictionary["InsertionTime"] as? String
            popReceipt = dictionary["PopReceipt"] as? String
            timeNextVisible = dictionary["TimeNextVisible"] as? String
            
            if let encodedText = dictionary["MessageText"] as? String {
                messageText = QueueMessage.decodeMessage(encodedText)
                rawDictionary["MessageText"] = messageText
            } else {
                messageText = nil
            }
            
            if messageId == nil || messageText == nil || dequeueCount == nil || expirationTime == nil || insertionTime == nil {
                return nil
            }
        }
        
        public func prop(key: String?) -> String? {
            if let k = key {
                return rawDictionary[k] as? String
            }
            return nil
        }
        
        class func decodeMessage(message: String) -> String {
            if let decodedData = NSData(base64EncodedString: message, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                return NSString(data: decodedData, encoding: NSUTF8StringEncoding) as! String
            }
            return ""
        }
    }
}
