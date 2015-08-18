//
//  Utility.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 8/18/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation

func randomStringWithLength(len: Int) -> String {
    let letters: NSString = "abcdefghijklmnopqrstuvwxyz"
    var randomString : NSMutableString = NSMutableString(capacity: len)
    for i in 0..<len {
        var length = UInt32(letters.length)
        var rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    return randomString as String
}

