//
//  PeekMessageRequest.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public extension AzureQueue {
    public class PeekMessagesRequest: GetMessagesRequestBase {
        override func parameters() -> [String] {
            var array = super.parameters()
            array.append("peekonly=true")
            return array
        }
    }
}
