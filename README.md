# NervosSwift

NervosSwift is a native Swift framework for working with Smart Contract and integrating with clients on Nervos network.

## Features

* HTTP provider for connecting to Nervos testnet or any AppChain network.
* Implementation of Nervos JSON-RPC API over HTTP.
* Signer for sining a Nervos transaction.

## RPC API

Refer to [docs.nervos.org/cita](https://docs.nervos.org/cita/#/rpc_guide/rpc) for a complete list of Nervos JSON-RPC API.

## Get Started

### Prerequisites

* Swift 4.1
* iOS 9 and above
* [CocoaPods](https://cocoapods.org)

### Installation

To integrate NervosSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'YourTargetName' do
  use_frameworks!

  pod 'NervosSwift', git: 'https://github.com/cryptape/nervos-swift'
end
```

Then, run the following command:

```bash
$ pod install
```

### web3swift

NervosSwift is built based on [BANKEX/web3swift](https://github.com/BANKEX/web3swift). While it's unnecessary to import `web3swift` when using NervosSwift, the following classes are simply typealias of web3swift's Ethereum types:

| NervosSwift Types | web3swift Type      |
|:-----------------:|:-------------------:|
| Utils             | Web3Utils           |
| NervosError       | Web3Error           |
| NervosOptions     | Web3Options         |
| Address           | EthereumAddress     |
| EventLog          | EventLog            |
| BloomFilter       | EthereumBloomFilter |

### Testnet

For tests, use the recommended Nervos AppChain testnet http://121.196.200.225:1337.

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
let tx = NervosTransaction(
    to: Address("0x0000000000000000000000000000000000000000")!,
    nonce: "12345", // Generate a random or unique nonce string
    data: Data.fromHex("6060604...")!,
    validUntilBlock: 999999,
    chainId: 1
)
guard let signed = try? NervosTransactionSigner.sign(transaction: tx, with: privateKey) else {
  print("Sign fail")
}
```

## RPC API Reference

TODO

## License

NervosSwift is released under the [MIT License](https://github.com/cryptape/NervosSwift/blob/master/LICENSE).
