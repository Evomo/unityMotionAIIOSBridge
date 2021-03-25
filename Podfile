# Evomo private specs repo source
source 'https://bitbucket.org/evomo/evomopodsrelease.git'

# Standard cocoapods specs source
source 'https://github.com/CocoaPods/Specs.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

target 'EvomoUnitySDK' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	
  pod "EvomoMotionAI/Basic", '1.8.13'
  #, :path => '~/evomo/swift/frameworks/evomomotionaiframework'
end

target 'EvomoUnitySDKMovesense' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod "EvomoMotionAI/Movesense", '1.8.13'
  #, :path => '~/evomo/swift/frameworks/evomomotionaiframework'

end

post_install do |installer|
    
  # ------------------- add movesense lib
  
  lib_name = "libmds.a"
  lib_path = "Movesense/IOS/Movesense/Release-iphoneos"
  
  # get ref of lib file
  path = File.dirname(__FILE__) + "/Pods/" + lib_path + "/" + lib_name
  movesense_ref = installer.pods_project.reference_for_path(path)
  
  installer.pods_project.targets.each do |target|
    
    # find the right target
    if target.name == 'Pods-EvomoUnitySDKMovesense'|| target.name == 'Pods-TestApp' || target.name == 'EvomoMotionAI-Basic-Movesense'
      print "Add movesense lib\n"
      # add libmds.a file to build files
      build_phase = target.frameworks_build_phase
      build_phase.add_file_reference(movesense_ref)
      
      target.build_configurations.each do |config|
        # add library search paths
        config.build_settings['LIBRARY_SEARCH_PATHS'] = ["$(inherited)", "$(PROJECT_DIR)/" + lib_path]
                
      end
    end
  end
end
