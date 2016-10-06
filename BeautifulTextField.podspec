#
# Be sure to run `pod lib lint BeautifulTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BeautifulTextField'
  s.version          = '0.9.2'
  s.summary          = 'BeautifulTextField is just a Beautiful UITextField with small customization.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
BeautifulTextField is just a UITextField with small customization. You can custumize it how you want!
                       DESC

  s.homepage         = 'https://github.com/CoolCodeFactory/BeautifulTextField.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dmitry Utmanov' => 'utm4@mail.ru' }
  s.source           = { :git => 'https://github.com/CoolCodeFactory/BeautifulTextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BeautifulTextField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BeautifulTextField' => ['BeautifulTextField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
