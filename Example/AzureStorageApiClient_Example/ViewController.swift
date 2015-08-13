//
//  ViewController.swift
//  AzureStorageApiClient_Example
//
//  Created by Hiromasa Ohno on 8/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import AzureStorageApiClient

class ViewController: UIViewController {
    
    var client : AzureStorage.Client?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        client = AzureStorage.Client(accoutName: Config.Account, accessKey: Config.Key, accountDomain: Config.Domain, useHTTPS: true)
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
    
    func listQueues() {
        let request = AzureQueue.ListQueuesRequest()
        client?.call(request, handler: handleResponse)
    }
    
    func createQueue() {
        let request = AzureQueue.CreateQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func deleteQueue() {
        let request = AzureQueue.DeleteQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func putMessage() {
        let request = AzureQueue.PutMessagesRequest(queue: "queuename", message: "a message", messageTTL: 3600, visibilityTimeout: 600)
        client?.call(request, handler: handleResponse)
    }
    
    func getMessages() {
        let request = AzureQueue.GetMessagesRequest(queue: "queuename", visibilityTimeout: 600, numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }
    
    func peekMessage() {
        let request = AzureQueue.PeekMessagesRequest(queue: "queuename", numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }
    
    func deleteMessage() {
        let request = AzureQueue.DeleteMessageRequest(queue: "queuename", messageId: "message-id(UUID)", popReceipt: "pop-receipt")
        client?.call(request, handler: handleResponse)
    }
    
    func clearMessage() {
        let request = AzureQueue.ClearMessagesRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }
    
    func updateMessage() {
        let request = AzureQueue.UpdateMessageRequest(queue: "queuename", message: "new message", messageId: "message-id(UUID)", popReceipt: "pop-receipt", visibilityTimeout: 3600)
        client?.call(request, handler: handleResponse)
    }
}

