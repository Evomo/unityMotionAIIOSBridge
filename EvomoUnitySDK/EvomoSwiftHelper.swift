//
//  EvomoSwiftHelper.swift
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//

import Foundation
import EvomoMotionAI

let deviceIphone = Device(deviceID: "", deviceType: .iPhone, devicePosition: .hand,
                          deviceOrientation: .buttonDown, classificationModel: "2115")

//let licenseID = "800ff7ea-521b-4d5f-b1f9-c04e90d665fa"

@objc public class EvomoSwiftHelper: NSObject {
        
    @objc public static func initEvomo(unityBridge : EvomounityBridge, licenseID: String) {
        
        // set licenseID
        ClassificationControlLayer.shared.setLicense(licenseID: licenseID)
        
        // optional inpug: debugging
        
        let unityBridge: EvomounityBridge = EvomounityBridge()
        
        var lastElmo: ElementalMovement? = nil
        
        ClassificationControlLayer.shared.elementalMovementHandler = { elementalMovement in
            // Will be executed every time a elementalMovement was classified
            
            DispatchQueue.main.async {
                // execute movement event in main thread
                if !elementalMovement.rejected {
                    print("EvomoMovement: \(elementalMovement.typeLabel)")
                    
                    switch(elementalMovement.typeLabel) {
                    case "hop_single_up":
                        unityBridge.jump()
                    case "duck down":
                        unityBridge.duck()
                    case "side_step_left_up":
                        unityBridge.left()
                    case "side_step_right_up":
                        unityBridge.right()
                    default:
                        print("default")
                    }
                    
                    // rescue rejected elmo
                    if let lastElmo = lastElmo {
                        if lastElmo.rejected == true && elementalMovement.rejected == false {
                            if lastElmo.typeLabel == "duck down" && elementalMovement.typeLabel == "duck up"  {
                                // rescue hop
                                unityBridge.duck()
                            } else if lastElmo.typeLabel == "hop_single_up" && elementalMovement.typeLabel == "hop_single_down"  {
                                // rescue hop
                                unityBridge.jump()
                            } else if lastElmo.typeLabel == "side_step_left_up" && elementalMovement.typeLabel == "side_step_left_down"  {
                                // rescue hop
                                unityBridge.left()
                            } else if lastElmo.typeLabel == "side_step_right_up" && elementalMovement.typeLabel == "side_step_right_down"  {
                                // rescue hop
                                unityBridge.right()
                            }
                        }
                    }
                }
            }
            lastElmo = elementalMovement
        }
        
        
        ClassificationControlLayer.shared.debugging = true
        ClassificationControlLayer.shared.gaming = true
        
        // only used to load model on init
//        ClassificationControlLayer.shared.setLicense(licenseID: licenseID)
//        ClassificationControlLayer.shared.getAvailableMovements(device: deviceIphone).done{ mTypes in
//            print("Evomo - getAvailableMovements", mTypes)
//        }.catch{ error in
//            print("Evomo - getAvailableMovements", error)
//        }
        
    }
    
    @objc public static func startEvomo() {
        // Define device
                                      
            print("Start classification")
                  // Start
                  ClassificationControlLayer.shared.start(
                      devices: [deviceIphone],
                      licenseID: nil,
                      isStarted: {
                          print("Evomo - Started!")
                          
                  },
                      isFailed: {error in print("Evomo - startClassification:  \(error)")}
                  )
       }
    
    @objc public static func stopEvomo() {
        _ = ClassificationControlLayer.shared.stop()
    }
    
    @objc public static func logEvent(eventType: String, note: String?) {
        ClassificationControlLayer.shared.logEvent(eventType: eventType, note: eventType)
    }
    
    @objc public static func logTargetMovement(movementType: String, note: String?) {
        ClassificationControlLayer.shared.logTargetMovement(movementType: movementType, note: nil)
    }
    
    @objc public static func logFailure(source: String, failureType: String, movementType: String, note: String?) {
        
        let sourceEnum: FailureSource
        switch source {
        case "app":
            sourceEnum = .app
        default:
            sourceEnum = .manual
        }
        
        let failureTypeEnum: FailureType
        switch failureType {
        case "toLess":
            failureTypeEnum = .toLess
        default:
            failureTypeEnum = .toMuch
        }
        
        ClassificationControlLayer.shared.logFailure(source: sourceEnum, failureType: failureTypeEnum, movementType: movementType, note: note)
    }
    
    
}

