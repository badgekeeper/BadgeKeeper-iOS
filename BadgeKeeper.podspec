Pod::Spec.new do |s|
  s.name             = "BadgeKeeper"
  s.version          = "0.1.0"
  s.summary          = "BadgeKeeper service lightweight client library."
  s.homepage         = "https://github.com/HDSRepo/BadgeKeeper-iOS"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Alexander Pukhov" => "" }
  s.source           = { :git => "https://github.com/HDSRepo/BadgeKeeper-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/badge_keeper'

  s.platform     = :ios, '4.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'test' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end