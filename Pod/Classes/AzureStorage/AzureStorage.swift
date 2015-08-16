//
//  AzureStorage.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import XMLDictionary

public class AzureStorage {
    class func xmlResponseToDictionary(responseObject: AnyObject?) -> NSDictionary? {
        if let data = responseObject as? NSData {
            let parser = NSXMLParser(data: data)
            return NSDictionary(XMLParser: parser)
        } else {
            return nil
        }
    }
}
public class AzureBlob {}
public class AzureQueue {}
