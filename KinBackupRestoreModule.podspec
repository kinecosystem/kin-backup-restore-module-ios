Pod::Spec.new do |s|
  s.name              = 'KinBackupRestoreModule'
  s.version           = '1.0.0'
  s.license           = { :type => 'Kin Ecosystem SDK License', :file => 'LICENSE.md' }
  s.author            = { 'Kin Foundation' => 'info@kin.org' }
  s.summary           = 'Pod for the Kin Backup and Restore Module.'
  s.homepage          = 'https://github.com/kinecosystem/kin-backup-restore-module-ios'
  s.documentation_url = 'https://kinecosystem.github.io/kin-website-docs/docs/documentation/backup-restore-ios'
  s.social_media_url  = 'https://twitter.com/kin_foundation'
  
  s.platform      = :ios, '9.0'
  s.swift_version = '5.0'

  s.source       = { 
    :git => 'https://github.com/kinecosystem/kin-backup-restore-module-ios.git', 
    :tag => s.version.to_s,
    :submodules => true
  }
  s.source_files = 'KinBackupRestoreModule/KinBackupRestoreModule/**/*.swift'
  s.resources    = 'KinBackupRestoreModule/KinBackupRestoreModule/*.{strings,xcassets}'

  s.dependency 'KinSDK', '~> 1.0.0'  
end
