Pod::Spec.new do |s|
  s.name         = "AppChainSwift"
  s.version      = "0.19.3"
  s.summary      = "Nervos AppChain SDK implementation in Swift for iOS"

  s.description  = <<-DESC
  Nervos AppChain SDK implementation in Swift for iOS, intended for mobile developers of wallets and Dapps.
  DESC

  s.homepage     = "https://github.com/cryptape/appchain-swift"
  s.license      = "MIT"
  s.author       = { "Cryptape" => "contact@cryptape.com" }
  s.source       = { git: "https://github.com/cryptape/appchain-swift.git", tag: "v#{s.version.to_s}" }
  s.social_media_url = 'https://twitter.com/nervosnetwork'

  s.swift_version = '4.2'
  s.module_name = 'AppChain'
  s.ios.deployment_target = "10.0"
  s.source_files = "Source/**/*.{h,swift}"
  s.public_header_files = "Source/**/*.{h}"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'web3swift', '~> 1.1.10'
  s.dependency 'SwiftProtobuf', '~> 1.0.3'
end
