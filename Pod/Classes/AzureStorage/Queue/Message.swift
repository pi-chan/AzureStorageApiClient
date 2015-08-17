//
//  Message.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/04.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class Message : AzureStorage.Item {
        public var messageId: String? { get { return rawDictionary.valueForKeyPath("MessageId") as? String } }
        public var messageText: String? { get { return rawDictionary.valueForKeyPath("MessageText") as? String } }
        public var dequeueCount: String? { get { return rawDictionary.valueForKeyPath("DequeueCount") as? String } }
        public var expirationTime: String? { get { return rawDictionary.valueForKeyPath("ExpirationTime") as? String } }
        public var insertionTime: String? { get { return rawDictionary.valueForKeyPath("InsertionTime") as? String } }
        public var popReceipt: String? { get { return rawDictionary.valueForKeyPath("PopReceipt") as? String } }
        public var timeNextVisible: String? { get { return rawDictionary.valueForKeyPath("TimeNextVisible") as? String } }
        
        override init(dictionary: NSDictionary) {
            super.init(dictionary: dictionary)
            if var encodedText = dictionary["MessageText"] as? String {
                rawDictionary["MessageText"] = ResponseUtility.decodeMessage(encodedText)
            }
        }
        
    }
}
