# CITA Swift SDK

[![Travis](https://travis-ci.com/cryptape/cita-sdk-swift.svg?branch=develop)](https://travis-ci.com/cryptape/cita-sdk-swift)
[![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/)

[English](./README.md) | 简体中文

cita-sdk-swift 是用于集成 [CITA](https://www.citahub.com/) 的原生 Swift SDK.

## 特性
* 连接到 [CITA](https://www.citahub.com/) 网络的HTTP提供程序。
* 通过 HTTP 协议，实现了 CITA 所定义的所有 JSON-RPC 方法。
* 对交易进行签名

## RPC 接口
请参考[docs.nervos.org/cita](https://docs.nervos.org/cita/#/rpc_guide/rpc)来查看 CITA 的 JSON-RPC 接口列表。


## 开始

### 系统要求
如果你想构建 CITA SDK，你需要：
* Swift 5.0 及以后。
* Xcode 10.2 及以后
* [CocoaPods](https://cocoapods.org)

### 安装
通过 [CocoaPods](https://cocoapods.org) 把 CITA SDK 集成到你的项目中，你需要在你的 `Podfile` 指定：
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'YourTargetName' do
  use_frameworks!

  pod 'CITA', git: 'https://github.com/cryptape/cita-sdk-swift'
end
```
然后在 `Podfile` 文件目录下运行：

```bash
$ pod install
```
### 开发

下载源码：
```shell
git clone --recursive https://github.com/cryptape/cita-sdk-swift.git
pod install
cp Tests/Config.example.json Tests/Config.json
```
使用 Xcode 打开 `CITA.xcworkspace` 进行构建。

### 运行测试代码
运行 `CITATests` target。如果你要自定义 CITA 的节点或者链，请配置 `Tests/Config.json` 文件中的 `rpcServer` 的值。默认值是 `http://127.0.0.1:1337` 。

注意：有多个测试实例依赖于链上的数据，这可能会造成在您自己的链上运行失败。我们将来会改进测试并解决这个问题。

### web3swift
CITA SDK 原来是基于 [matterinc/web3swift](https://github.com/matterinc/web3swift) 的，但是我们希望 CITA SDK 是一个简单的能管理 RPC 接口和
进行交易签名的工具（这意味着我们就不需要 `keystore` 管理和其他的一些功能），所以我们移除了 `web3swift` 的依赖，不过一些工具类、类扩展和 HTTP 请求的
实现都参考了 web3swift 。

### 测试网络

使用 CITA 测试网络（推荐）：  
http://121.196.200.225:1337  

或者可以部署你自己的 CITA：  
如果需要了解怎么部署 CITA 网络，请查阅[CITA](https://github.com/cryptape/cita)。

### HTTPProvider

通过 `HTTPProvider` 你可以连接到 CITA 测试网或者其他任何网络，使用方法如下：

```swift
import CITA

let testnetUrl = URL(string: "http://121.196.200.225:1337")! // Or use any other network
// let testnetUrl = URL(string: "https://node.cryptape.com")! // Also available
let provider = HTTPProvider(testnetUrl)
```

### CITA

`CITA` 是一个通过 `HTTPProvider` 跟 CITA 网络进行通信的类。通过 `CITA.rpc` 可以访问任何 JSON-RPC 接口。

```swift
let cita = CITA(provider: provider)
let peerCount = cita.rpc.peerCount().value!
```


### 交易和签名

在通过 JSON-RPC 接口发送原始交易之前，请创建一个 `Transaction` 对象并且用 `Signer` 类进行签名：

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

## RPC 接口参考
如果请求成功，所有的 JSON-RPC 接口都会返回结果，否则抛出 `CITAError` 。

因为 JSON-RPC 接口请求方法是同步的，所以底层的 HTTP 请求可能会需要一些时间来返回结果，在这个项目中，请求通常通过 `promise` 来实现。
所以尽量不要在主线程中调用 RPC 接口，防止阻塞主线程。

常用的调用接口、处理结果的方式如下：

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

## 许可证明

CITA SDK 遵守 [MIT License](https://github.com/cryptape/cita-sdk-swift/blob/master/LICENSE) 协议。



