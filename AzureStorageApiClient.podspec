#
# Be sure to run `pod lib lint AzureStorageApiClient.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AzureStorageApiClient"
  s.version          = "1.2"
  s.summary          = "AzureStorageApiClient is api client library for Microsost Azure Storage in Swift."
  s.homepage         = "https://github.com/xoyip/AzureStorageApiClient"
  s.license          = 'MIT'
  s.author           = { "xoyip" => "xoyip@piyox.info" }
  s.source           = { :git => "https://github.com/xoyip/AzureStorageApiClient.git", :tag => s.version.to_s }

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "8.0"

  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'AFNetworking', '~> 2.5'
  s.dependency 'CryptoSwift', '~> 0.0'
  s.dependency 'XMLDictionary', '~> 1.4'
  s.dependency 'Regex', '~> 0.2'
end
