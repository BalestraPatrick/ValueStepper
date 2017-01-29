#
# Be sure to run `pod lib lint ValueStepper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ValueStepper"
  s.version          = "1.1.3"
  s.summary          = "A Stepper object that displays its value."
  s.description      = "ValueStepper is an improved replication of Apple's UIStepper object. The problem with UIStepper is that it doesn't display the value to the user. I was tired of creating a simple UILabel just to show the value in the UI. ValueStepper integrates the value in a UILabel between the increase and decrease buttons. It's as easy as that."

  s.homepage         = "https://github.com/BalestraPatrick/ValueStepper"
  s.license          = 'MIT'
  s.author           = { "Patrick Balestra" => "me@patrickbalestra.com" }
  s.source           = { :git => "https://github.com/BalestraPatrick/ValueStepper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BalestraPatrick'

  s.platform     = :ios, '8.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
