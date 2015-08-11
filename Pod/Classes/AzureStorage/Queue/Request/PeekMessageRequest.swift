//
//  PeekMessageRequest.swift
//  azurequeue
//
//  Created by Hiromasa Ohno on 2015/08/06.
//  Copyright (c) 2015 CFlat. All rights reserved.
//

import Foundation

public extension AzureStorage {
    public class PeekMessagesRequest: FetchMessagesRequest {
        override func parameters() -> [String] {
            var array = super.parameters()
            array.append("peekonly=true")
            return array
        }
    }
}
