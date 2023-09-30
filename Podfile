platform :ios, '12.0'

CocoaCDNPods = 'https://cdn.cocoapods.org/'
CocoaPods = 'https://github.com/CocoaPods/Specs.git'

source CocoaPods

def Release()

  #第三方
  pod 'SnapKit', '5.0.0'
  pod 'MJRefresh', '3.7.5'
  pod 'RxSwift', '6.2.0' # 响应式
  pod 'RxCocoa', '6.2.0' # 响应式
  pod 'CocoaLumberjack/Swift'
#  pod 'RxAlamofire'
  pod 'Kingfisher', '7.6.1'
  pod 'RxDataSources'
  pod 'Moya/RxSwift'
  pod 'MBProgressHUD'
  pod 'KMNavigationBarTransition'
  pod "ESTabBarController-swift"
  
  
end

def Debug()

  pod 'LookinServer', :configurations => ['Debug']
  
end


target 'ZQMusic' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks

  use_modular_headers!

  Release()
  Debug()
  
end


# 处理三方库编译设置
post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|

    if target.platform_name == :ios then
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings["VALID_ARCHS"] = "arm64 arm64e x86_64 i386"
          config.build_settings['ONLY_ACTIVE_ARCH'] = "NO"
          config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
        else
          config.build_settings["VALID_ARCHS"] = "arm64 arm64e"
        end
        #config.build_settings['VALID_ARCHS'] = 'arm64 arm64e x86_64' #
#        config.build_settings['EXCLUDED_ARCHS'] = 'armv7 armv7s ' # i386
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
    
  end
end
