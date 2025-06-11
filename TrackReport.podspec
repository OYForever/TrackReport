Pod::Spec.new do |s|
  s.name             = "TrackReport"
  s.version          = "1.0.5"
  s.summary          = "TrackReport components"
  
  
  s.homepage         = "https://github.com/OYForever"
  s.license          = "MIT"
  s.author           = "MIT"
  s.source           = { :git => "https://github.com/OYForever/TrackReport.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "13.0"
  s.swift_versions = "5.0"
  
  s.source_files = "TrackReport/src/**/*.{swift}"
  s.resources = ["TrackReport/src/Resource/PrivacyInfo.xcprivacy", "TrackReport/src/Resource/TrackReport.bundle"]
  s.preserve_paths = "TrackReport/src/**/*"
  
end
