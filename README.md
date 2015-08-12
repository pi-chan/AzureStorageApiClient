# AzureStorageApiClient

AzureStorageApiClient is api client library for Microsost Azure Storage in Swift.
This library only supports MS Azure Queue Storage.

## Installation

### Cocoapods

```ruby
pod 'AzureStorageApiClient'
```

## Usage

### Queue

```swift
import AzureStorageApiClient

class FooBar {
    private let client = AzureStorage.Client(accoutName: "account", accessKey: "key", accountDomain: "domain", useHTTPS: true)

    func handleResponse<T>(response: Response<T>) {
        switch response {
        case .Success(let wrapper):
            println(wrapper.value)
        case .Failure(let wrapper):
            println(wrapper.value)
        }
    }

    // lists all of the queues in a given storage account
    func listQueues() {
        let request = AzureStorage.ListQueuesRequest()
        client?.call(request, handler: handleResponse)
    }

    // creates a queue under the given account
    func createQueue() {
        let request = AzureStorage.CreateQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // permanently deletes the specified queue
    func deleteQueue() {
        let request = AzureStorage.DeleteQueueRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // adds a new message to the back of the message queue
    func putMessage() {
        let request = AzureStorage.PutMessagesRequest(queue: "queuename", message: "a message", messageTTL: 3600, visibilityTimeout: 600)
        client?.call(request, handler: handleResponse)
    }

    // retrieves one or more messages from the front of the queue
    func getMessages() {
        let request = AzureStorage.GetMessagesRequest(queue: "queuename", visibilityTimeout: 600, numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }

    // retrieves one or more messages from the front of the queue, but does not alter the visibility of the message
    func peekMessage() {
        let request = AzureStorage.PeekMessagesRequest(queue: "queuename", numberOfMessages: 32)
        client?.call(request, handler: handleResponse)
    }

    // deletes the specified message
    func deleteMessage() {
        let request = AzureStorage.DeleteMessageRequest(queue: "queuename", messageId: "message-id(UUID)", popReceipt: "pop-receipt")
        client?.call(request, handler: handleResponse)
    }

    // deletes all messages from the specified queue
    func clearMessage() {
        let request = AzureStorage.ClearMessagesRequest(queue: "queuename")
        client?.call(request, handler: handleResponse)
    }

    // updates the visibility timeout of a message, the contents of a message
    func updateMessage() {
        let request = AzureStorage.UpdateMessageRequest(queue: "queuename", message: "new message", messageId: "message-id(UUID)", popReceipt: "pop-receipt", visibilityTimeout: 3600)
        client?.call(request, handler: handleResponse)
    }
}
```

## How to run sample app

1. Copy `Example/AzureStorageApiClient_Example/Config.sample.swift` to `Example/AzureStorageApiClient_Example/Config.swift`
- Edit variables in `Example/AzureStorageApiClient_Example/Config.swift`. -> [Microsoft Azure Portal](https://manage.windowsazure.com/)
- Open `Example/AzureStorageApiClient.xcworkspace` and run application.

## Dependencies

- [AFNetworking/AFNetworking](https://github.com/AFNetworking/AFNetworking "AFNetworking/AFNetworking")
- [nicklockwood/XMLDictionary](https://github.com/nicklockwood/XMLDictionary "nicklockwood/XMLDictionary")
- [krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift "krzyzanowskim/CryptoSwift")

## Author

Hiromasa OHno

## License

AzureStorageApiClient is available under the MIT license. See the LICENSE file for more info.
