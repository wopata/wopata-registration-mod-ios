Pod::Spec.new do |s|
  s.name             = 'WopataLogin'
  s.version          = '4.0.0'
  s.summary          = 'WopataLogin is a social/native sign-signup module for iOS'

  s.homepage         = 'git@github.com:wopata/wopata-registration-mod-ios.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wopata' => 'contact@wopata.com' }
  s.source           = { :git => 'git@github.com:wopata/wopata-registration-mod-ios.git', :tag => "v#{s.version.to_s}" }

  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '4.0' }
  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/**/*.swift'
  s.resource_bundles = { 
    'WopataLogin' => ['Source/Images.xcassets','Source/Localizations/*.lproj/Localizable.strings'],
    'GoogleSignIn' => ['Source/Google/GoogleSignIn.bundle']
  }

  s.dependency 'SnapKit', '~> 4.0.0'
# s.dependency 'FacebookCore', '~> 0.2.0'
# s.dependency 'FacebookLogin', '~> 0.2.0'
# s.dependency 'FacebookShare', '~> 0.2.0'
  s.dependency 'FBSDKCoreKit', '~> 4.27'
  s.dependency 'FBSDKLoginKit', '~> 4.27'
  s.dependency 'FBSDKShareKit', '~> 4.27'

  s.frameworks = 'SafariServices', 'SystemConfiguration'
  s.vendored_frameworks = 'Source/Google/*.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }
end
