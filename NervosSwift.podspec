Pod::Spec.new do |s|
  s.name         = "NervosSwift"
  s.version      = "0.17.2"
  s.summary      = "Nervos SDK implementation in Swift for iOS"

  s.description  = <<-DESC
  Nervos SDK implementation in Swift for iOS, intended for mobile developers of wallets and Dapps.
  DESC

  s.homepage     = "https://github.com/cryptape/nervos-swift"
  s.license      = "MIT"
  s.author       = { "Cryptape" => "contact@cryptape.com" }
  s.source       = { git: "https://github.com/cryptape/nervos-swift.git", tag: "v#{s.version.to_s}" }
  s.social_media_url = 'https://twitter.com/nervosnetwork'

  s.swift_version = '4.2'
  s.module_name = 'Nervos'
  s.ios.deployment_target = "10.0"
  s.source_files = "Source/**/*.{h,swift}"
  s.public_header_files = "Source/**/*.{h}"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'web3swift', '~> 1.1.1'
  s.dependency 'SwiftProtobuf', '~> 1.0.3'
end
