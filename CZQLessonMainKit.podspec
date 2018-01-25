#
# Be sure to run `pod lib lint CZQLessonMainKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CZQLessonMainKit'
  s.version          = '0.1.10'
  s.summary          = 'CZQLessonMainKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: CZQLessonMainKit 主页组件.
                       DESC

  s.homepage         = 'https://github.com/IUCoco/CZQLessonMainKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'IUCoco' => 'czq1157111246@gmail.com' }
  s.source           = { :git => 'https://github.com/IUCoco/CZQLessonMainKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CZQLessonMainKit/Classes/**/*.{h,m}'

  s.resource_bundles = {
  'CZQLessonMainKit' => ['CZQLessonMainKit/Assets/Home/**/*', 'CZQLessonMainKit/Classes/**/*.xib']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'CZQLessonCategoryKit/Frame'
  s.dependency 'SDWebImage'
  s.dependency 'SDCycleScrollView'
  s.dependency 'CZQLessonServerKit'
  s.dependency 'MJExtension'
  s.dependency 'SVProgressHUD'
end
