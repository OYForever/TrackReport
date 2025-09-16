Pod::Spec.new do |s|
  s.name             = "TrackReport"
  s.version          = "1.1.0"
  s.summary          = "TrackReport components"
  
  
  s.homepage         = "https://github.com/OYForever"
  s.license          = "MIT"
  s.author           = "MIT"
  s.source           = { :git => "https://github.com/OYForever/TrackReport.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "13.0"
  s.swift_versions = "5.0"
  
  s.source_files = "TrackReport/src/**/*.{swift}"
  s.resources = [
    "TrackReport/src/Resource/TrackReport.bundle"
  ]
  s.resource_bundle = { 'TrackReport_Privacy' => ["TrackReport/src/Resource/PrivacyInfo.xcprivacy"] }
  
  s.dependency "FirebaseAnalytics"
  s.dependency "FirebaseRemoteConfig"
  s.dependency "FirebaseCrashlytics"
  
  s.frameworks = "AdSupport"
  
end
