//
//  Client.swift
//  Pods
//
//  Created by Hiromasa Ohno on 8/13/15.
//
//

import Foundation

public extension AzureQueue {
    public class Client : AzureStorage.Client {
        override func service() -> String {
            return "queue"
        }
    }
}
