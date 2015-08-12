//
//  Client.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/30.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import AFNetworking
import XMLDictionary
import CryptoSwift

extension AzureStorage {
    public class Client {
        let scheme : String!
        let key : String!
        let name : String!
        let domain : String!
        
        public init?(accoutName: String, accessKey: String, accountDomain: String, useHTTPS: Bool) {
            scheme = useHTTPS ? "https" : "http"
            key = accessKey
            name = accoutName
            domain = accountDomain
        }
        
        private func host() -> String {
            return "\(name).queue.\(domain)"
        }
        
        public func call<T: Request>(request: T, handler: (Response<T.Response>) -> Void = { r in }) {
            let success = { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                let dictionary = XMLDictionaryParser.sharedInstance().dictionaryWithParser(responseObject as? NSXMLParser)
                let statusCode = (task.response as? NSHTTPURLResponse)?.statusCode
                switch (statusCode, request.convertJSONObject(dictionary)) {
                case (.Some(200..<300), .Some(let response)):
                    handler(Response(response))
                default:
                    let userInfo = [NSLocalizedDescriptionKey: "unresolved error occurred."]
                    let error = NSError(domain: "WebAPIErrorDomain", code: 0, userInfo: userInfo)
                    handler(Response(error))
                }
            }
            
            let failure = { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                handler(Response(error))
            }
            
            let url = scheme + "://" + host() + request.path()
            let manager = configuredManager(request)
            
            switch request.method {
            case "GET":
                manager.GET(url, parameters: nil, success: success, failure: failure)
            case "POST":
                manager.requestSerializer.setQueryStringSerializationWithBlock { (request, params, error) -> String! in
                    return params as! String
                }
                manager.POST(url, parameters: request.body(), success: success, failure: failure)
            case "PUT":
                manager.requestSerializer.setQueryStringSerializationWithBlock { (request, params, error) -> String! in
                    return params as! String
                }
                manager.PUT(url, parameters: request.body(), success: success, failure: failure)
            case "DELETE":
                manager.DELETE(url, parameters: nil, success: success, failure: failure)
            default:
                break
            }
        }
        
        private func configuredManager<T: Request>(request: T) -> AFHTTPSessionManager {
            let url = scheme + "://" + host() + request.path()
            
            var headers = Dictionary<String, String>()
            headers["x-ms-date"] = dateString()
            headers["x-ms-version"] = "2012-02-12"
            headers.merge(request.additionalHeaders())
            
            var signer = Signer(name: name, key: key)
            var sign = signer.signature(request.method, uri: url, headers: headers)
            headers["Authorization"] = "SharedKey \(name):\(sign)"
            
            var manager = AFHTTPSessionManager()
            for (key, value) in headers {
                manager.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
            manager.responseSerializer = AFXMLParserResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = ["application/xml"]
            return manager
        }
        
        private func dateString() -> String {
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.timeZone = NSTimeZone(name: "UTC")
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            return formatter.stringFromDate(date)
        }
    }
}