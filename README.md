# CITA Swift SDK

[![Travis](https://travis-ci.com/cryptape/cita-sdk-swift.svg?branch=develop)](https://travis-ci.com/cryptape/cita-ask-swift)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)

Native Swift SDK for integrating with [CITA](https://www.citahub.com/).

## Features

* HTTP provider for connecting to CITA networks.
* Implementation of CITA JSON-RPC API over HTTP.
* Signer for signing transaction.

## RPC API

Refer to [docs.nervos.org/cita](https://docs.nervos.org/cita/#/rpc_guide/rpc) for a complete list of CITA JSON-RPC API.

## Get Started

### System Requirements

To build CITA SDK, you'll need:

* Swift 4.2 and later
* Xcode 10 and later
* [CocoaPods](https://cocoapods.org)

### Installation

To integrate CITA SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'YourTargetName' do
  use_frameworks!

  pod 'CITA', git: 'https://github.com/cryptape/cita-sdk-swift'
end
```

Then, run the following command:

```bash
$ pod install
```

### Development

Fetch the source code:

```shell
git clone --recursive https://github.com/cryptape/cita-sdk-swift.git
pod install
cp Tests/Config.example.json Tests/Config.json
```

Then open `CITA.xcworkspace` with Xcode and build.

#### Running Tests

Run tests from `CITATests` target. Update `rpcServer` value of `Tests/Config.json` file if you want to test against another CITA node or chain of your choice. By default `http://127.0.0.1:1337` is used.

Note: serveral tests depend on onchain data and would fail when running on your own chain. We're going to improve the tests and fix that in the near future.

### web3swift

CITA SDK was initially built upon [matterinc/web3swift](https://github.com/matterinc/web3swift). Then we want to keep this a simple RPC client and transaction signer (this means no keystore management and other features) so web3swift dependency was removed, but some utils, foundation extensions and HTTP request implementations were taken and modified from it.

### Testnet

For test or development, you can follow the [CITA document](https://docs.nervos.org/cita/) to run a local chain. We also provide a public testnet at http://121.196.200.225:1337 (or use https://node.cryptape.com).

This testnet supports [CITA](https://github.com/cryptape/cita) version **v0.20**.

### HTTPProvider

`HTTPProvider` connects to CITA testnet or any other network. To construct a provider:

```swift
import CITA

let testnetUrl = URL(string: "http://121.196.200.225:1337")! // Or use any other network
// let testnetUrl = URL(string: "https://node.cryptape.com")! // Also available
let provider = HTTPProvider(testnetUrl)
```

### CITA

`CITA` is the class that talks to CITA network through `HTTPProvider`. Consume any JSON-RPC API with `CITA` instance's `rpc` property.

```swift
let cita = CITA(provider: provider)
let peerCount = cita.rpc.peerCount().value!
```

### Transaction and Signer

Before sending a raw transaction over JSON-RPC API, create a `Transaction` object and sign it with private key using `Signer`:

```swift
let privateKey = "0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
guard let metaData = try? cita.rpc.getMetaData(), let blockNumber = try? cita.rpc.blockNumber() else {
    return
}
let metaData = try? cita.rpc.getMetaData()
let tx = Transaction(
    to: Address("0x0000000000000000000000000000000000000000"),
    nonce: UUID().uuidString, // Generate a random/unique nonce string
    quota: 1_000_000, // Use 1,000,000 as default quota for sending a transaction
    validUntilBlock: blockNumber + 88,
    data: Data.fromHex("6060604...")!,
    chainId: metaData.chainId,
    version: metaData.version

)
guard let signed = try? Signer().sign(transaction: tx, with: privateKey) else {
    print("Sign fail")
}
```

## RPC API Reference

All JSON-RPC APIs would return result when the call is successful, or throw `CITAError` exception when not.

JSON-RPC API functions are synchronous. But the underlying HTTP request might take some time to return, and in this project they're usually implemented in some `promise` way. It's generally better to call API function in a background queue so it won't block the main thread.

A common flow to call an API and handle the result is as follows.

```swift
DispatchQueue.global().async {
    do {
        let peerCount = try cita.rpc.peerCount()
        DispatchQueue.main.async {
            print("CITA peer count: \(count)")
        }
    } catch let error {
        DispatchQueue.main.async {
            print(error.localizedDescription)
        }
    }
}
```

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
* [getBlockHeader](#getblockheader)
* [getStateProof](#getstateproof)

### peerCount

```swift
/// Get the number of CITA peers currently connected to the client.
///
/// - Returns: Peer count.
func peerCount() throws -> BigUInt
```

### blockNumber

```swift
/// Get the number of most recent block.
///
/// - Returns: Current block height.
func blockNumber() throws -> UInt64
```

### sendRawTransaction

```swift
/// Send signed transaction to CITA.
///
/// - Parameter signedTx: Signed transaction hex string.
///
/// - Returns: Transaction hash.
func sendRawTransaction(signedTx: String) throws -> String
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
func getBlockByHash(hash: String, fullTransactions: Bool = false) throws -> Block
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
func getBlockByNumber(number: BigUInt, fullTransactions: Bool = false) throws -> Block
```

### getTransactionReceipt

```swift
/// Get the receipt of a transaction by transaction hash.
///
/// - Parameter txhash: transaction hash hex string.
///
/// - Returns: The receipt of transaction matching the txhash.
func getTransactionReceipt(txhash: String) throws -> TransactionReceipt
```

### getLogs

```swift
/// Get all logs matching a given filter object.
///
/// - Parameter filter: The filter object.
///
/// - Returns: An array of all logs matching the filter.
func getLogs(filter: Filter) throws -> [EventLog]
```

### call

```swift
/// Execute a new call immediately on a contract.
///
/// - Parameters:
///    - request: A call request.
///    - blockNumber: A block number
///
/// - Returns: The call result as hex string.
func call(request: CallRequest, blockNumber: String = "latest") throws -> String
```

### getTransaction

```swift
/// Get a transaction for a given hash.
///
/// - Parameter txhash: The transaction hash hex string.
///
/// - Returns: A transaction details object.
func getTransaction(txhash: String) throws -> TransactionDetails
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
func getTransactionCount(address: String, blockNumber: String = "latest") throws -> BigUInt
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
func getCode(address: String, blockNumber: String = "latest") throws -> String
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
func getAbi(address: String, blockNumber: String = "latest") throws -> String
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
func getBalance(address: String, blockNumber: String = "latest") throws -> BigUInt
```

### newFilter

```swift
/// Create a new filter object.
///
/// - Parameter filter: The filter option object.
///
/// - Returns: ID of the new filter.
func newFilter(filter: Filter) throws -> BigUInt
```

### newBlockFilter

```swift
/// Create a new block filter object.
///
/// - Parameter filter: The filter option object.
///
/// - Returns: ID of the new block filter.
func newBlockFilter() throws -> BigUInt
```

### uninstallFilter

```swift
/// Uninstall a filter. Should always be called when watch is no longer needed.
/// Additonally Filters timeout when they aren't requested with getFilterChanges for a period of time.
///
/// - Parameter filterID: ID of the filter to uninstall.
///
/// - Returns: True if the filter was successfully uninstalled, otherwise false.
func uninstallFilter(filterID: BigUInt) throws -> Bool
```

### getFilterChanges

```swift
/// Get an array of logs which occurred since last poll.
///
/// - Parameter filterID: ID of the filter to get changes from.
///
/// - Returns: An array of logs which occurred since last poll.
func getFilterChanges(filterID: BigUInt) throws -> [EventLog]
```

### getFilterLogs

```swift
/// Get an array of all logs matching filter with given id.
///
/// - Parameter filterID: ID of the filter to get logs from.
///
/// - Returns: An array of logs matching the given filter id.
func getFilterLogs(filterID: BigUInt) throws -> [EventLog]
```

### getTransactionProof

```swift
/// Get transaction proof by a given transaction hash.
///
/// - Parameter txhash: The transaction hash.
///
/// - Returns: A proof include transaction, receipt, receipt merkle tree proof, block header.
///     There will be a tool to verify the proof and extract some info.
func getTransactionProof(txhash: String) throws -> String
```

### getMetaData

```swift
/// Get CITA metadata by a given block height.
///
/// - Parameter blockNumber: The block height, hex string integer or "latest".
///
/// - Returns: Metadata of given block height.
func getMetaData(blockNumber: String = "latest") throws -> MetaData
```

### getBlockHeader

```swift
/// Get block header by a given block height.
///
/// - Parameter blockNumber: The block height, hex string integer or "latest".
///
/// - Returns: block header of the given block height.
func getBlockHeader(blockNumber: String = "latest") throws -> String
```

### getStateProof

```swift
/// Get state proof of special value. Include address, account proof, key, value proof.
///
/// - Parameters:
///    - address: An address.
///    - key: A key, position of the variable.
///    - blockNumber: The block number, hex string integer, or the string "latest", "earliest".
///
/// - Returns: State proof of special value. Include address, account proof, key, value proof.
func getStateProof(address: String, key: String, blockNumber: String = "latest") throws -> String
```

## License

CITA SDK is released under the [MIT License](https://github.com/cryptape/cita-sdk-swift/blob/master/LICENSE).
