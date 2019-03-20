Pod::Spec.new do |s|
  s.name         = "CITA"
  s.version      = "0.22.0"
  s.summary      = "CITA SDK implementation in Swift for iOS"

  s.description  = <<-DESC
  CITA SDK implementation in Swift for iOS, intended for mobile developers of wallets and Dapps.
  DESC

  s.homepage     = "https://github.com/cryptape/cita-sdk-swift"
  s.license      = "MIT"
  s.author       = { "Cryptape" => "contact@cryptape.com" }
  s.source       = { git: "https://github.com/cryptape/cita-sdk-swift.git", tag: "v#{s.version.to_s}" }

  s.swift_version = '4.2'
  s.module_name = 'CITA'
  s.ios.deployment_target = "10.0"
  s.source_files = "Source/**/*.{h,swift}"
  s.public_header_files = "Source/**/*.{h}"
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.dependency 'SwiftProtobuf', '~> 1.2.0'
  s.dependency 'secp256k1_swift', '~> 1.0.3'
  s.dependency 'CryptoSwift', '~> 0.13'
  s.dependency 'BigInt', '~> 3.1'
  s.dependency 'PromiseKit', '~> 6.5'
end
