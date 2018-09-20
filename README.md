# NervosSwift

[![Travis](https://travis-ci.com/cryptape/nervos-swift.svg?branch=develop)](https://travis-ci.com/cryptape/nervos-swift)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![AppChain](https://img.shields.io/badge/made%20for-Nervos%20AppChain-blue.svg)](https://appchain.nervos.org)

NervosSwift is a native Swift framework for working with Smart Contract and integrating with clients on Nervos network.

## Features

* HTTP provider for connecting to Nervos testnet or any AppChain network.
* Implementation of Nervos JSON-RPC API over HTTP.
* Signer for signing a Nervos transaction.

## RPC API

Refer to [docs.nervos.org/cita](https://docs.nervos.org/cita/#/rpc_guide/rpc) for a complete list of Nervos JSON-RPC API.

## Get Started

### System Requirements

To build NervosSwift, you'll need:

* Swift 4.2 or later
* Xcode 10 or later
* [CocoaPods](https://cocoapods.org)

NervosSwift supports iOS 10 and newer versions.

### Installation

To integrate NervosSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'YourTargetName' do
  use_frameworks!

  pod 'NervosSwift', git: 'https://github.com/cryptape/nervos-swift'
end
```

Then, run the following command:

```bash
$ pod install
```

### Development

To build NervosSwift, first run `pod install`, then open `Nervos.xcworkspace` with Xcode and build.

#### Running Tests

Copy `Tests/Config.example.json` to `Tests/Config.json`, then run tests from `NervosTests` target. Update `rpcServer` value of `Tests/Config.json` file if you want to test against an AppChain of your choice. By default `http://127.0.0.1:1337` is used.

### web3swift

NervosSwift is built upon [BANKEX/web3swift](https://github.com/BANKEX/web3swift). While it's not required to import `web3swift` when using NervosSwift, please note the following classes are simply typealias of web3swift's Ethereum types:

| NervosSwift Type  | web3swift Type      |
|:-----------------:|:-------------------:|
| Utils             | Web3Utils           |
| NervosError       | Web3Error           |
| NervosOptions     | Web3Options         |
| EthereumAddress   | EthereumAddress     |
| EventLog          | EventLog            |
| BloomFilter       | EthereumBloomFilter |

### Testnet

For tests, use the recommended Nervos AppChain testnet http://121.196.200.225:1337.

This testnet supports [CITA](https://github.com/cryptape/cita) version **v0.17**.

### NervosProvider

`NervosProvider` is the HTTP provider to connect to Nervos AppChain testnet or any other network. To construct a provider:

```swift
import Nervos

let testnetUrl = URL(string: "http://121.196.200.225:1337")! // Or use any other AppChain network
let provider = NervosProvider(testnetUrl)
```

### Nervos

`Nervos` is the class that talks to AppChain network through `NervosProvider`. Consume any JSON-RPC API with Nervos' `appChain` property.

```swift
let nervos = Nervos(provider)
let peerCount = nervos.appChain.peerCount().value!
```

### NervosTransaction and NervosTransactionSigner

Before sending a raw transaction over JSON-RPC API, create a `NervosTransaction` object and sign it with private key using `NervosTransactionSigner`:

```swift
let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
let currentBlock = nervos.appChain.blockNumber().value!
let tx = NervosTransaction(
    to: Address("0x0000000000000000000000000000000000000000"),
    nonce: UUID().uuidString, // Generate a random/unique nonce string
    quota: 1_000_000, // Use 1,000,000 as default quota for sending a transaction
    validUntilBlock: currentBlock + 88,
    data: Data.fromHex("6060604...")!,
    chainId: 1
)
guard let signed = try? NervosTransactionSigner.sign(transaction: tx, with: privateKey) else {
    print("Sign fail")
}
```

## RPC API Reference

All JSON-RPC APIs return `Result<Value, NervosError>`, where `Value` is the actual type of the result when the call is successful.

A common flow to call an API and handle the result is as follows:

```swift
let result = nervos.appChain.peerCount()
switch result {
case .success(let count):
    print("AppChain peer count: \(count)")
case .failure(let error):
    print(error.localizedDescription)
}
```

### Important Notices

All JSON-RPC API functions are synchronous. But the underlying HTTP request might take some time to return, and in NervosSwift they're usually implemented in some `promise` way. It's generally better to call API function in a background queue so it won't block the main thread.

* [peerCount](#peercount)
* [blockNumber](#blocknumber)
* [sendRawTransaction](#sendrawtransaction)
* [getBlockByHash](#getblockbyhash)
* [getBlockByNumber](#getblockbynumber)
* [getTransactionReceipt](#gettransactionreceipt)
* [getLogs](#getlogs)
* [call](#call)
* [getTransaction](#gettransaction)
* [getTransactionCount](#gettransactioncount)
* [getCode](#getcode)
* [getAbi](#getabi)
* [getBalance](#getbalance)
* [newFilter](#newfilter)
* [newBlockFilter](#newblockfilter)
* [uninstallFilter](#uninstallfilter)
* [getFilterChanges](#getfilterchanges)
* [getFilterLogs](#getfilterlogs)
* [getTransactionProof](#gettransactionproof)
* [getMetaData](#getmetadata)

### peerCount

```swift
/// Get the number of AppChain peers currently connected to the client.
///
/// - Returns: Peer count.
func peerCount() -> Result<BigUInt, NervosError>
```

### blockNumber

```swift
/// Get the number of most recent block.
///
/// - Returns: Current block height.
func blockNumber() -> Result<UInt64, NervosError>
```

### sendRawTransaction

```swift
/// Send signed transaction to AppChain.
///
/// - Parameter signedTx: Signed transaction hex string.
///
/// - Returns: Transaction sending result.
func sendRawTransaction(signedTx: String) -> Result<TransactionSendingResult, NervosError>
```

### getBlockByHash

```swift
/// Get a block by hash.
///
/// - Parameters:
///     - hash: The block hash hex string.
///     - fullTransactions: Whether to include transactions in the block object.
///
/// - Returns: The block object matching the hash.
func getBlockByHash(hash: String, fullTransactions: Bool = false) -> Result<Block, NervosError>
```

### getBlockByNumber

```swift
/// Get a block by number.
///
/// - Parameters:
///     - number: The block number.
///     - fullTransactions: Whether to include transactions in the block object.
///
/// - Returns: The block object matching the number.
func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) -> Result<Block, NervosError>
```

### getTransactionReceipt

```swift
/// Get the receipt of a transaction by transaction hash.
///
/// - Parameter txhash: transaction hash hex string.
///
/// - Returns: The receipt of transaction matching the txhash.
func getTransactionReceipt(txhash: String) -> Result<TransactionReceipt, NervosError>
```

### getLogs

```swift
/// Get all logs matching a given filter object.
///
/// - Parameter filter: The filter object.
///
/// - Returns: An array of all logs matching the filter.
func getLogs(filter: Filter) -> Result<[EventLog], NervosError>
```

### call

```swift
/// Execute a new call immediately on a contract.
///
/// - Parameters:
///    - request: A call request.
///    - blockNumber: A block number
///
/// - Returns: The transaction hash.
func call(request: CallRequest, blockNumber: String = "latest") -> Result<String, NervosError>
```

### getTransaction

```swift
/// Get a transaction for a given hash.
///
/// - Parameter txhash: The transaction hash hex string.
///
/// - Returns: A transaction details object.
func getTransaction(txhash: String) -> Result<TransactionDetails, NervosError>
```

### getTransactionCount

```swift
/// Get the number of transactions sent from an address.
///
/// - Parameters:
///    - address: An address to check for transaction count for.
///    - blockNumber: A block number.
///
/// - Returns: The number of transactions.
func getTransactionCount(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError>
```

### getCode

```swift
/// Get code at a given address.
///
/// - Parameters:
///    - address: An address of the code.
///    - blockNumber: A block number.
///
/// - Returns: The code at the given address.
func getCode(address: String, blockNumber: String = "latest") -> Result<String, NervosError>
```

### getAbi

```swift
/// Get ABI at a given address.
///
/// - Parameters:
///    - address: An address of the ABI.
///    - blockNumber: A block number.
///
/// - Returns: The ABI at the given address.
func getAbi(address: String, blockNumber: String = "latest") -> Result<String, NervosError>
```

### getBalance

```swift
/// Get the balance of the account of given address.
///
/// - Parameters:
///    - address: An address.
///    - blockNumber: A block number.
///
/// - Returns: The balance of the account of the give address.
func getBalance(address: String, blockNumber: String = "latest") -> Result<BigUInt, NervosError>
```

### newFilter

```swift
/// Create a new filter object.
///
/// - Parameter filter: The filter option object.
///
/// - Returns: ID of the new filter.
func newFilter(filter: Filter) -> Result<BigUInt, NervosError>
```

### newBlockFilter

```swift
/// Create a new block filter object.
///
/// - Parameter filter: The filter option object.
///
/// - Returns: ID of the new block filter.
func newBlockFilter() -> Result<BigUInt, NervosError>
```

### uninstallFilter

```swift
/// Uninstall a filter. Should always be called when watch is no longer needed.
/// Additonally Filters timeout when they aren't requested with getFilterChanges for a period of time.
///
/// - Parameter filterID: ID of the filter to uninstall.
///
/// - Returns: True if the filter was successfully uninstalled, otherwise false.
func uninstallFilter(filterID: BigUInt) -> Result<Bool, NervosError>
```

### getFilterChanges

```swift
/// Get an array of logs which occurred since last poll.
///
/// - Parameter filterID: ID of the filter to get changes from.
///
/// - Returns: An array of logs which occurred since last poll.
func getFilterChanges(filterID: BigUInt) -> Result<[EventLog], NervosError>
```

### getFilterLogs

```swift
/// Get an array of all logs matching filter with given id.
///
/// - Parameter filterID: ID of the filter to get logs from.
///
/// - Returns: An array of logs matching the given filter id.
func getFilterLogs(filterID: BigUInt) -> Result<[EventLog], NervosError>
```

### getTransactionProof

```swift
/// Get transaction proof by a given transaction hash.
///
/// - Parameter txhash: The transaction hash.
///
/// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
///     There will be a tool to verify the proof and extract some info.
func getTransactionProof(txhash: String) -> Result<String, NervosError>
```

### getMetaData

```swift
/// Get AppChain metadata by a given block height.
///
/// - Parameter blockNumber: The block height, hex string integer or "latest".
///
/// - Returns: Metadata of given block height.
func getMetaData(blockNumber: String = "latest") -> Result<MetaData, NervosError>
```

## License

NervosSwift is released under the [MIT License](https://github.com/cryptape/NervosSwift/blob/master/LICENSE).
