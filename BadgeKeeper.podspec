Pod::Spec.new do |s|
  s.name             = "BadgeKeeper"
  s.version          = "0.1.7"
  s.summary          = "BadgeKeeper service lightweight client library."
  s.homepage         = "https://github.com/badgekeeper/BadgeKeeper-iOS"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Alexander Pukhov" => "" }
  s.source           = { :git => "https://github.com/badgekeeper/BadgeKeeper-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/badge_keeper'

  s.platform     = :ios, '4.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*', 'Pod/Classes/Entities/BadgeKeeper.xcdatamodeld', 'Pod/Classes/Entities/BadgeKeeper.xcdatamodeld/*.xcdatamodel'
  s.resources = [ 'Pod/Classes/Entities/BadgeKeeper.xcdatamodeld','Pod/Classes/Entities/BadgeKeeper.xcdatamodeld/*.xcdatamodel']
  s.preserve_paths = 'Pod/Classes/Entities/BadgeKeeper.xcdatamodeld'

  s.frameworks = 'CoreData'
end