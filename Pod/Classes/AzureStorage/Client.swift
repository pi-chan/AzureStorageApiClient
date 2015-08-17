//
//  Client.swift
//  AzureStorageApiClient
//
//  Created by Hiromasa Ohno on 2015/07/30.
//  Copyright (c) 2015 Hiromasa Ohno. All rights reserved.
//

import Foundation
import AFNetworking
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
        
        internal func service() -> String {
            return ""
        }
        
        private func host() -> String {
            return "\(name).\(service()).\(domain)"
        }
        
        public func call<T: Request>(request: T, handler: (Response<T.Response>) -> Void = { r in }) {
            
            let handleError = { () -> Void in
                let userInfo = [NSLocalizedDescriptionKey: "unresolved error occurred."]
                let error = NSError(domain: "WebAPIErrorDomain", code: 0, userInfo: userInfo)
                handler(Response(error))
            }
            
            let success = { (task: NSURLSessionDataTask!, responseObject: AnyObject!) -> Void in
                let statusCode = (task.response as? NSHTTPURLResponse)?.statusCode
                switch (statusCode, request.convertResponseObject(responseObject)) {
                case (.Some(200..<300), .Some(let response)):
                    handler(Response(response))
                default:
                    handleError()
                }
            }
            
            let headSuccess = { (task: NSURLSessionDataTask!) -> Void in
                let response = task.response as? NSHTTPURLResponse
                switch (response?.statusCode, request.convertResponseObject(response?.allHeaderFields)) {
                case (.Some(200..<300), .Some(let response)):
                    handler(Response(response))
                default:
                    handleError()
                }
            }
            
            let failure = { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
                handler(Response(error))
            }
            
            let url = scheme + "://" + host() + request.path()
            let manager = configuredManager(request)
            
            switch request.method {
            case "HEAD":
                manager.HEAD(url, parameters: nil, success: headSuccess, failure: failure)
            case "GET":
                manager.GET(url, parameters: nil, success: success, failure: failure)
            case "POST":
                manager.POST(url, parameters: request.body(), success: success, failure: failure)
            case "PUT":
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
            headers["x-ms-version"] = "2014-02-14"
            headers.merge(request.additionalHeaders())
            
            var signer = Signer(name: name, key: key)
            var sign = signer.signature(request.method, uri: url, headers: headers)
            headers["Authorization"] = "SharedKey \(name):\(sign)"
            
            var manager = AFHTTPSessionManager()
            if let data = request.body() {
                manager.requestSerializer = AzureStorageRequetSerializer()
            }
            for (key, value) in headers {
                manager.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
            manager.responseSerializer = AFHTTPResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = request.responseTypes()
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