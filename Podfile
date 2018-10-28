source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'AppChain' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "SwiftProtobuf", "~> 1.2.0"
  pod "secp256k1_swift", "~> 1.0.3", modular_headers: true
  pod "CryptoSwift", "~> 0.13"
  pod "BigInt", "~> 3.1"
  pod "Result", "~> 4.0"
  pod "PromiseKit", "~> 6.4"

  target 'AppChainTests' do
    inherit! :search_paths
  end
end
