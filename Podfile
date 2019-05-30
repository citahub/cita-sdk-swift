source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'CITA' do
  use_frameworks!
  use_modular_headers!
  inhibit_all_warnings!

  pod "SwiftProtobuf", "~> 1.2.0"
  pod "secp256k1.swift", "~> 0.1.4"
  pod "CryptoSwift", "~> 1.0.0"
  pod "BigInt", "~> 3.1"
  pod "PromiseKit", "~> 6.8.4"

  pod "SwiftLint"
end

target 'CITATests' do
  use_frameworks!
  inherit! :search_paths
end
