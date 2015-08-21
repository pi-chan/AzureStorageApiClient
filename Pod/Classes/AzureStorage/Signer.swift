//
//  Signer.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/31.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import CryptoSwift
import Regex

extension AzureStorage {
    class Signer {
        
        var name: String!
        var key: String!
        
        init(name: String, key: String) {
            self.name = name
            self.key = key
        }
        
        func signature(method: String, uri: String, headers: Dictionary<String, String>) -> String {
            let message = signableString(method, uri: uri, headers: headers)
            println(message)
            let decodedData = NSData(base64EncodedString: key, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            if let data = decodedData {
                var bytes : [UInt8] = data.arrayOfBytes()
                if let sign = Authenticator.HMAC(key: bytes, variant: HMAC.Variant.sha256).authenticate([UInt8](message.utf8)) {
                    let data = NSData.withBytes(sign)
                    let encoded = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                    return encoded
                }
            }
            return ""
        }
        
        private func signableString(method: String, uri: String, headers: Dictionary<String,String>) -> String {
            var array : [String] = [
                method.uppercaseString,
                headers.valueForKey("Content-Encoding", defaultValue: ""),
                headers.valueForKey("Content-Language", defaultValue: ""),
                headers.valueForKey("Content-Length", defaultValue: ""),
                headers.valueForKey("Content-Md5", defaultValue: ""),
                headers.valueForKey("Content-Type", defaultValue: ""),
                headers.valueForKey("Date", defaultValue: ""),
                headers.valueForKey("If-Modified-Since", defaultValue: ""),
                headers.valueForKey("If-Match", defaultValue: ""),
                headers.valueForKey("If-None-Match", defaultValue: ""),
                headers.valueForKey("If-Unmodified-Since", defaultValue: ""),
                headers.valueForKey("Range", defaultValue: ""),
                canonicalizedHeaders(headers),
                canonicalizedResource(uri)
            ]
            return join("\n", array)
        }
        
        private func canonicalizedHeaders(headers : Dictionary<String,String>) -> String {
            var array = map(headers, { (key, value) in
                return [key.lowercaseString, value]
            }).filter({ (values: [String]) -> Bool in
                return values[0].grep("^x-ms-").boolValue
            }).sorted({ (v0, v1) -> Bool in
                return v0[0] < v1[0]
            }).map({ (values) -> String in
                return "\(values[0]):\(values[1])"
            }).map({ (value: String) -> String in
                return value.replaceRegex("\\s+", with: " ")
            })
            return join("\n", array)
        }
        
        private func canonicalizedResource(uri : String) -> String {
            var url = NSURL(string: uri)!
            var resource = "/" + name
            if url.path == nil || url.path!.isEmpty {
                resource = resource + "/"
            } else {
                resource = resource + url.path!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            }
            
            var array = map(url.parameters(), { (key, value) in
                return [key.lowercaseString, value]
            }).sorted({ (v0, v1) -> Bool in
                return v0[0] < v1[0]
            }).map({ (values) -> String in
                var str = values[1].replaceRegex("(^\\s+|\\s+$)", with: "").replaceRegex("%3D", with: "=")
                return "\(values[0]):\(str)"
            })
            array.insert(resource, atIndex: 0)
            return join("\n", array)
        }
    }
}
