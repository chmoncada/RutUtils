#
# Be sure to run `pod lib lint chileanRutUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'chileanRutUtils'
  s.version          = '0.1.0'
  s.summary          = 'Helper methods to validate and generate RUT Chilean numbers'

  s.homepage         = 'https://github.com/chmoncada/chileanRutUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chmoncada' => 'chmoncada@me.com' }
  s.source           = { :git => 'https://github.com/chmoncada/chileanRutUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.swift_versions = ['5.0', '5.1']

  s.source_files = 'chileanRutUtils/Classes/**/*'
end
