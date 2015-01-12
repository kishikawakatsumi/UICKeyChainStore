Pod::Spec.new do |s|
  s.name                  = "UICKeyChainStore"
  s.version               = "2.0.0"
  s.summary               = "UICKeyChainStore is a simple wrapper for Keychain on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults."
  s.homepage              = "https://github.com/kishikawakatsumi/UICKeyChainStore"
  s.social_media_url      = "https://twitter.com/k_katsumi"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "kishikawa katsumi" => "kishikawakatsumi@mac.com" }
  s.source                = { :git => "https://github.com/kishikawakatsumi/UICKeyChainStore.git", :tag => "v#{s.version}" }

  s.ios.deployment_target = "4.3"
  s.osx.deployment_target = "10.7"
  s.requires_arc          = true

  s.source_files          = "Lib/UICKeyChainStore/*.{h,m}"

  s.framework             = "Security"
end
