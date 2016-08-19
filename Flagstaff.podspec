Pod::Spec.new do |s|
  s.name             = 'Flagstaff'
  s.version          = '0.1.1'
  s.summary          = 'Feature flagging for iOS'
  s.homepage         = 'https://github.com/NickEntin/flagstaff-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nick Entin' => 'nick@entin.io' }
  s.source           = { :git => 'https://github.com/NickEntin/flagstaff-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nckntn'

  s.ios.deployment_target = '7.0'

  s.source_files = 'Flagstaff/Classes/**/*'
end
