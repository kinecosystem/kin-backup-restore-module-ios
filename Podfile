# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

workspace 'KinBackupRestoreModule'

target 'KinBackupRestoreModule' do
  project 'KinBackupRestoreModule/KinBackupRestoreModule.xcodeproj'

  pod 'KinSDK', :git => 'https://github.com/kinecosystem/kin-sdk-ios.git'

  # Fixes the framework tests failing to build
  target 'KinBackupRestoreModuleTests' do
    inherit! :search_paths
  end
end

target 'KinBackupRestoreSampleApp' do
  project 'KinBackupRestoreSampleApp/KinBackupRestoreSampleApp.xcodeproj'

  pod 'KinBackupRestoreModule', :path => './'
end