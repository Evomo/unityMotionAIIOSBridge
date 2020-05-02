

Pod::Spec.new do |spec|
    
    spec.name         = "EvomoUnitySDK"
    spec.version      = "1.0.2"
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
    
    spec.source       = { :git => "https://github.com/Evomo/unityMotionAISDK", :tag => "#{spec.version}" }
    
    spec.source_files  = "EvomoUnitySDK"
    
    spec.dependency 'EvomoMotionAI/Basic'
    
end
