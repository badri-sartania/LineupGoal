platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def shared_pods
	# https://github.com/AFNetworking/AFNetworking/releases
	pod 'AFNetworking', '2.6.0'

	# https://github.com/zwaldowski/BlocksKit/commits/master
	pod 'BlocksKit'

	# https://developers.facebook.com/docs/ios/change-log-4.x
	pod 'FBSDKCoreKit', '4.10.0'
	pod 'FBSDKLoginKit', '4.10.0'

	# https://github.com/mixpanel/mixpanel-iphone/releases
	pod 'Mixpanel', '2.9.4'

	# https://developers.helpshift.com/ios/release-notes/
	pod 'Helpshift', '5.3.0-support'

	# https://github.com/JonasGessner/JGProgressHUD/releases
	pod 'JGProgressHUD', '1.3.1'

	# https://github.com/Masonry/Masonry/blob/master/CHANGELOG.md
	pod 'Masonry', '0.6.4'

	# https://github.com/SnapKit/SnapKit/blob/develop/CHANGELOG.md
	pod 'SnapKit', '~> 4.0.0'

	# https://github.com/dogo/SCLAlertView/releases
	pod 'SCLAlertView-Objective-C', '0.7.9'

	# https://github.com/yannickl/YLMoment/commits/master
	pod 'YLMoment', '0.6.0'

	# https://github.com/mineschan/MZTimerLabel/releases
	pod 'MZTimerLabel', '0.5.4'

	# http://docs.fabric.io/ios/changelog.html
    	pod 'Fabric'
    	pod 'Crashlytics'

	# https://github.com/Mantle/Mantle/releases
	pod 'Mantle', '2.0.6'

	# https://www.firebase.com/docs/ios/changelog.html
	pod 'Firebase', '2.5.1'

	# https://github.com/slackhq/SlackTextViewController/releases
	pod 'SlackTextViewController', '1.9'

	# https://github.com/oarrabi/OAStackView/blob/master/CHANGELOG.md
	pod 'OAStackView', '1.0.1'

	# https://github.com/tomvanzummeren/TZStackView
	pod 'TZStackView', '1.3.0'

	# https://github.com/JaNd3r/CKTextField/releases
	pod 'CKTextField', '0.2.0'

	# https://github.com/mRs-/HexColors/releases
	pod 'HexColors', '~> 3.1.1'

	# https://github.com/aschuch/StatefulViewController/releases
	pod 'StatefulViewController', :git => "https://github.com/tomdev-biz/StatefulViewController.git"
	pod 'ReactiveCocoa', '2.3.1'
	pod 'ReactiveViewModel', '0.2'

	# https://github.com/malcommac/SwiftDate/blob/master/CHANGELOG.md
	pod 'SwiftDate'

	pod 'ForceTouchGestureRecognizer'
	pod 'SMPageControl'
	pod 'CustomBadge'
	pod 'VVBlurPresentation'

	pod 'UIScrollSlidingPages', :git => 'https://github.com/tomdev-biz/UIScrollSlidingPages.git'
	#pod 'XipSlideDownView', :git => 'https://github.com/xiplias/XipSlideDown.git'
    
    # https://github.com/cwRichardKim/RKSwipeBetweenViewControllers/releases
    pod 'RKSwipeBetweenViewControllers'
    
    # https://github.com/devxoul/UITextView-Placeholder/releases
    pod 'UITextView+Placeholder', '~> 1.2'
end

target 'GoalFury' do
	shared_pods
end

#target 'LineupBattleStaging' do
#	shared_pods
#end

def testing_pods
    # If you're using Xcode 7 / Swift 2
    pod 'Quick'
    pod 'Nimble'
    pod 'Expecta', '~> 1.0.5'


end

target 'GoalFuryTests' do
    testing_pods
end

target 'GoalFuryUITests' do
    testing_pods
end

post_install do |installer|
    installer.aggregate_targets.each do |target|
        copy_pods_resources_path = "Pods/Target Support Files/#{target.name}/#{target.name}-resources.sh"
        string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
        assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
        text = File.read(copy_pods_resources_path)
        new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
        File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
    end
end

#post_install do |installer|
#    puts("Update debug pod settings to speed up build time")
#    Dir.glob(File.join("Pods", "**", "Pods*{debug,Private}.xcconfig")).each do |file|
#        File.open(file, 'a') { |f| f.puts "\nDEBUG_INFORMATION_FORMAT = dwarf" }
#    end
#end
