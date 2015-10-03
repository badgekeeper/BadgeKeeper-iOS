Pod::Spec.new do |s|
  s.name             = "BadgeKeeper"
  s.version          = "0.2.4"
  s.summary          = "BadgeKeeper service lightweight client library."
  s.homepage         = "https://github.com/badgekeeper/BadgeKeeper-iOS"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Alexander Pukhov" => "" }
  s.source           = { :git => "https://github.com/badgekeeper/BadgeKeeper-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/badge_keeper'
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{m,h}'

  s.dependency 'Realm'
  
end