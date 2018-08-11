# NervosSwift

NervosSwift is a native Swift framework for working with Smart Contract and integrating with clients on Nervos network.

## RPC API

https://docs.nervos.org/cita/#/rpc_guide/rpc

## Installation

### CocoaPods

To integrate NervosSwift into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:


```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'YourTargetName' do
  use_frameworks!

  pod 'NervosSwift', git: 'https://github.com/cryptape/nervos-swift-next'
end
```

Then, run the following command:

```bash
$ pod install
```

## License

NervosSwift is released under the [MIT License](https://github.com/cryptape/NervosSwift/blob/master/LICENSE).
