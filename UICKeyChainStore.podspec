Pod::Spec.new do |s|
  s.name                  = "UICKeyChainStore"
  s.version               = "2.1.0"
  s.summary               = "UICKeyChainStore is a simple wrapper for Keychain that works on iOS and OS X. Makes using Keychain APIs as easy as NSUserDefaults."
  s.description           = <<-DESC
                            UICKeyChainStore is a simple wrapper for Keychain that works on iOS and OS X.
                            Makes using Keychain APIs as easy as NSUserDefaults.

                            Features
                              - Simple interface
                              - Support access group
                              - [Support accessibility](#accessibility)
                              - [Support iCloud sharing](#icloud_sharing)
                              - **[Support TouchID and Keychain integration (iOS 8+)](#touch_id_integration)**
                              - Works on both iOS & OS X
                            DESC
  s.homepage              = "https://github.com/kishikawakatsumi/UICKeyChainStore"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "kishikawa katsumi" => "kishikawakatsumi@mac.com" }
  s.source                = { :git => "https://github.com/kishikawakatsumi/UICKeyChainStore.git", :tag => "v#{s.version}" }
  s.social_media_url      = "https://twitter.com/k_katsumi"

  s.ios.deployment_target = "4.3"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc          = true

  s.source_files          = "Lib/UICKeyChainStore/*.{h,m}"

  s.framework             = "Security"
end
