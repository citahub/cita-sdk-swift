source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'Nervos' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod 'web3swift', git: 'https://github.com/BANKEX/web3swift', tag: '1.1.1'
  pod 'SwiftProtobuf', git: 'https://github.com/apple/swift-protobuf.git', tag: '1.0.3'

  target 'NervosTests' do
    inherit! :search_paths
  end
end
