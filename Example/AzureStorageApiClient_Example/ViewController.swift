//
//  ViewController.swift
//  AzureStorageApiClient_Example
//
//  Created by Hiromasa Ohno on 8/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import AzureStorageApiClient
import BrightFutures

class ViewController: UIViewController {
   
    var blobClient : AzureBlob.Client!
    var queueClient : AzureQueue.Client!

    override func viewDidLoad() {
        super.viewDidLoad()
        blobClient = AzureBlob.Client(accoutName: Config.Account, accessKey: Config.Key, useHTTPS: true, hostName: nil)
        queueClient = AzureQueue.Client(accoutName: Config.Account, accessKey: Config.Key, useHTTPS: true, hostName: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleResponse<T>(response: Response<T>) {
        switch response {
        case .Success(let wrapper):
            println(wrapper.value)
        case .Failure(let wrapper):
            println(wrapper.value)
        }
    }
}

// MARK: Examples for Blob
extension ViewController {
    func listContainers() {
        let request = AzureBlob.ListContainersRequest()
        blobClient?.call(request, handler: handleResponse)
    }
    
    func getBlobServiceProperties() {
        let request = AzureBlob.GetBlobServicePropertiesRequest()
        blobClient?.call(request, handler: handleResponse)
    }
    
    func setBlobServiceCors() {
        var cors = AzureBlob.CorsRule(allowedOrigins: ["http://example.com"], allowedMethods: ["POST", "PUT"], allowedHeaders: ["*"], exposedHeaders: ["*"], maxAgeInSeconds: 10000)
        if let corsRule = cors {
            let request = AzureBlob.SetBlobServiceCorsRequest(rules: [corsRule])
            blobClient?.call(request, handler: handleResponse)
        }
    }
    
    func createContainer() {
        let request = AzureBlob.CreateContainerRequest(container: "containername", accessibility: .Private)
        blobClient?.call(request, handler: handleResponse)
    }
    
    func deleteContainer() {
        let request = AzureBlob.DeleteContainerRequest(container: "containername")
        blobClient?.call(request, handler: handleResponse)
    }
    
    func listBlobs() {
        let request = AzureBlob.ListBlobsRequest(container: "containername", maxResults: nil, nextMarker: nil)
        blobClient?.call(request, handler: handleResponse)
    }
    
    func putBlob() {
        if let url = NSURL(string: "https://avatars2.githubusercontent.com/u/3599510?v=3&s=10") {
            let data = NSData(contentsOfURL: url)!
            let request = AzureBlob.PutBlobRequest(container: "containername", name: "file.png", data: data, mimetype: "image/png")
            blobClient?.call(request, handler: handleResponse)
        }
    }
    
    func getBlob() {
        let request = AzureBlob.GetBlobRequest(container: "containername", name: "file.png", mimetype: "image/png")
        blobClient?.call(request, handler: handleResponse)
    }
    
    func getBlobProperties() {
        let request = AzureBlob.GetBlobPropertiesRequest(container: "containername", name: "file.png")
        blobClient?.call(request, handler: handleResponse)
    }
    
    func deleteBlob() {
        let request = AzureBlob.DeleteBlobRequest(container: "containername", name: "file.png")
        blobClient?.call(request, handler: handleResponse)
    }
}

// MARK: Examples for Queue
extension ViewController {
    func listQueues() {
        let request = AzureQueue.ListQueuesRequest()
        queueClient?.call(request, handler: handleResponse)
    }
    
    func createQueue() {
        let request = AzureQueue.CreateQueueRequest(queue: "queuename")
        queueClient?.call(request, handler: handleResponse)
    }
    
    func deleteQueue() {
        let request = AzureQueue.DeleteQueueRequest(queue: "queuename")
        queueClient?.call(request, handler: handleResponse)
    }
    
    func putMessage() {
        let request = AzureQueue.PutMessagesRequest(queue: "queuename", message: "a message", messageTTL: 3600, visibilityTimeout: 600)
        queueClient?.call(request, handler: handleResponse)
    }
    
    func getMessages() {
        let request = AzureQueue.GetMessagesRequest(queue: "queuename", visibilityTimeout: 600, numberOfMessages: 32)
        queueClient?.call(request, handler: handleResponse)
    }
    
    func peekMessage() {
        let request = AzureQueue.PeekMessagesRequest(queue: "queuename", numberOfMessages: 32)
        queueClient?.call(request, handler: handleResponse)
    }
    
    func deleteMessage() {
        let request = AzureQueue.DeleteMessageRequest(queue: "queuename", messageId: "message-id(UUID)", popReceipt: "pop-receipt")
        queueClient?.call(request, handler: handleResponse)
    }
    
    func clearMessage() {
        let request = AzureQueue.ClearMessagesRequest(queue: "queuename")
        queueClient?.call(request, handler: handleResponse)
    }
    
    func updateMessage() {
        let request = AzureQueue.UpdateMessageRequest(queue: "queuename", message: "new message", messageId: "message-id(UUID)", popReceipt: "pop-receipt", visibilityTimeout: 3600)
        queueClient?.call(request, handler: handleResponse)
    }
}

// MARK: Examples for BrightFutures' way
extension ViewController {
    func listCreateDelete() {
        let req1 = AzureQueue.ListQueuesRequest()
        queueClient.future(req1)
            .flatMap { response -> Future<AzureQueue.CreateQueueRequest.Response, NSError> in
                let req = AzureQueue.CreateQueueRequest(queue: "brandnewqueue")
                return self.queueClient.future(req)
            }
            .flatMap { response -> Future<AzureQueue.DeleteQueueRequest.Response, NSError> in
                let req = AzureQueue.DeleteQueueRequest(queue: "sample2")
                return self.queueClient.future(req)
            }
            .onSuccess { response in
                println(response)
            }
            .onFailure { error in
                println(error)
        }
    }
}
