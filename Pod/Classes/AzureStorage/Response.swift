//
//  Response.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/08/10.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation

public class Wrapper<T> {
    public let value: T
    
    init(_ value: T) {
        self.value = value
    }
}

// adopt Wrapper to avoid "unimplemented IR generation feature non-fixed multi-payload enum layout"
public enum Response<T> {
    case Success(Wrapper<T>)
    case Failure(Wrapper<NSError>)
    
    init(_ value: T) {
        self = .Success(Wrapper(value))
    }
    
    init(_ error: NSError) {
        self = .Failure(Wrapper(error))
    }
}

public class ResponseUtility {
    class func xmlResponseToDictionary(responseObject: AnyObject?) -> NSDictionary? {
        if let data = responseObject as? NSData {
            let parser = NSXMLParser(data: data)
            return NSDictionary(XMLParser: parser)
        } else {
            return nil
        }
    }
    
    class func responseItems<T:AzureStorage.Item>(object: AnyObject?, keyPath: String) -> Collection<T> {
        var items : [T] = []
        let response = ResponseUtility.xmlResponseToDictionary(object)
        for dictionary in ResponseUtility.dictionaryToDictionaryArray(response?.valueForKeyPath(keyPath)) {
            items.append(T(dictionary: dictionary))
        }
        let marker = response?.valueForKeyPath("NextMarker") as? String
        return Collection(items: items, nextMarker: marker)
    }
    
    class func decodeMessage(message: String) -> String {
        if let decodedData = NSData(base64EncodedString: message, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            return NSString(data: decodedData, encoding: NSUTF8StringEncoding) as! String
        }
        return ""
    }

    private class func dictionaryToDictionaryArray(dictionary: AnyObject?) -> [NSDictionary] {
        var dictionaries : [NSDictionary] = []
        if let aDicOrArray: AnyObject = dictionary {
            if let dics = aDicOrArray as? [NSDictionary] {
                dictionaries = dics
            } else {
                dictionaries = [(aDicOrArray as! NSDictionary)]
            }
        }
        return dictionaries
    }
}