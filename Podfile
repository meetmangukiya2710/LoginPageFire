# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LoginPageFire' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LoginPageFire

pod 'FirebaseAuth'
pod 'FirebaseFirestore'
pod 'TransitionButton'

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
    installer.pods_project.targets.each do |target|
        flutter_additional_ios_build_settings(target)
    end
end
