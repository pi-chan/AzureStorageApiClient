//
//  UpdateMessagesRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import Regex

public extension AzureStorage {
    public class UpdateMessageRequest: PutMessagesRequestBase {
        override public var method : String { get { return "PUT" } }
        let messageId : String
        let popReceipt : String
        let visibilityTimeout : Int
        
        public typealias Response = Bool
        
        public init(queue : String, message: String, messageId: String, popReceipt : String, visibilityTimeout: Int) {
            self.messageId = messageId
            self.popReceipt = popReceipt
            self.visibilityTimeout = visibilityTimeout
            super.init(queue: queue, message: message)
        }
        
        override internal func parameters() -> [String] {
            var equalReplacedStr : String = popReceipt.replaceRegex("=", with: "%3D")
            return ["popreceipt=\(equalReplacedStr)", "visibilitytimeout=\(String(visibilityTimeout))"]
        }
        
        override internal func basePath() -> String {
            return "/\(queue)/messages/\(messageId)"
        }
    }
}
