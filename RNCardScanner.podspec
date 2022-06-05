require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "RNCardScanner"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/howljs/rn-card-scanner.git", :tag => "#{s.version}" }

  s.vendored_frameworks = 'ios/CardScanner/PayCardsRecognizer.xcframework'
  s.source_files = ["ios/CardScanner/*.{h,m,mm,swift}", "ios/CardScanner/AppleVision/*.{h,m,mm,swift}"]
  s.requires_arc = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.resource_bundles = {
    'PortraitFrame' => ['ios/CardScanner/AppleVision/Resources/*.png'],
  }
  s.dependency "React-Core"
end
