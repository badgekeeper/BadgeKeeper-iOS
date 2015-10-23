Pod::Spec.new do |s|
  s.name             = "BadgeKeeper"
  s.version          = "0.2.8"
  s.summary          = "Badge Keeper service iOS client library."
  s.homepage         = "https://github.com/badgekeeper/BadgeKeeper-iOS"
  s.license          = { :type => "Apache 2.0", :file => "LICENSE" }
  s.author           = { "Badge Keeper" => "" }
  s.source           = { :git => "https://github.com/badgekeeper/BadgeKeeper-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/badge_keeper'
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'BadgeKeeper/**/*.{m,h}'

  s.dependency 'Realm'
  
end