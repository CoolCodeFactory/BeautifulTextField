#
# Be sure to run `pod lib lint BeautifulTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BeautifulTextField'
  s.version          = '0.9.9'
  s.summary          = 'BeautifulTextField is just a beautiful UITextField.'

  s.description      = <<-DESC
BeautifulTextField is just a beautiful UITextField. Easy to customize! Easy to use! Try it now!
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
