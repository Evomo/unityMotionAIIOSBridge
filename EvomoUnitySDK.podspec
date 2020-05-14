

Pod::Spec.new do |spec|
    
    spec.name         = "EvomoUnitySDK"
    spec.version      = "1.0.7"
    spec.summary      = "Unity Bridge for the Evomo MotionAI SDK."
    
    spec.description  = <<-DESC
    
    The Evomo MotionAI SDK for Unity allows to classify human gaming movements in realtime.
    
    DESC
    
    spec.homepage     = "http://www.evomo.de"
    spec.documentation_url     = "https://evomo.github.io/motionAI-docu/"
    
    spec.license      = { :type => 'MIT', :text => <<-LICENSE
        
        Copyright 2020
        This Wrapper for the EvomoMotionAI SDK is free to use under MIT-License.
        Please note the license terms of the Evomo MotionAI SDK.
        
        LICENSE
    }
    
    spec.author       = { "Jakob Wowy" => "jakob.wowy@evomo.de" }
    
    spec.platform     = :ios, "12.1"
    spec.swift_version = "5.0"
    
    spec.source       = { :git => "https://github.com/Evomo/unityMotionAIIOSBridge.git", :tag => "#{spec.version}" }
    
    s.subspec 'Source' do |source| {
    
        source.source_files  = "EvomoUnitySDK/*.{h,m,swift}"
        
        source.dependency 'EvomoMotionAI/Basic'
    }
    
    s.subspec 'Source' do |movesense| {
        movesense.source_files  = "EvomoUnitySDKMovesense/*.{h,m,swift}"
        
        movesense.dependency 'EvomoMotionAI/Movesense'
    }
    
end
