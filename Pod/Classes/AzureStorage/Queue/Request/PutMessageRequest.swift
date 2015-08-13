//
//  PutMessageRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class PutMessagesRequest: PutMessagesRequestBase {
        override public var method : String { get { return "POST" } }
        var messageTTL : Int?
        var visibilityTimeout : Int?
        
        public typealias Response = Bool
        
        public init(queue : String, message: String, messageTTL: Int?, visibilityTimeout: Int?) {
            self.messageTTL = messageTTL
            self.visibilityTimeout = visibilityTimeout
            super.init(queue: queue, message: message)
        }
        
        override internal func parameters() -> [String] {
            var params : [String] = []
            if let ttl = messageTTL {
                params.append("messagettl=\(ttl)")
            }
            if let visibility = visibilityTimeout {
                params.append("visibilitytimeout=\(visibility)")
            }
            return params
        }
        
        override internal func basePath() -> String {
            return "/\(queue)/messages"
        }
    }
}
