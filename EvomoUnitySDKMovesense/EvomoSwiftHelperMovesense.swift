//
//  EvomoSwiftHelper.swift
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//

import Foundation
import EvomoMotionAIMovesense

let deviceIphone = Device(deviceID: "", deviceType: .iPhone, devicePosition: .hand,
                          deviceOrientation: .buttonDown, classificationModel: "2115")

let licenseID = "800ff7ea-521b-4d5f-b1f9-c04e90d665fa"

@objc public class EvomoSwiftHelperMovesense: NSObject {
    
    @objc public static func initEvomo(unityBridge : EvomounityBridgeMovesense) {
        
        let unityBridge: EvomounityBridgeMovesense = EvomounityBridgeMovesense()
        
        var lastElmo: ElementalMovement? = nil
        
        ClassificationControlLayerMovesense.shared.elementalMovementHandler = { elementalMovement in
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
        
        
        ClassificationControlLayerMovesense.shared.debugging = true
        ClassificationControlLayerMovesense.shared.gaming = true
                
    }

    
    
    @objc public static func startEvomo() {
        // Define device

        ClassificationControlLayerMovesense.shared.startWithMovesense(licenseID: licenseID) { result in
            print("Start classification", result)
        }
        
    }
    
    @objc public static func stopEvomo() {
        ClassificationControlLayerMovesense.shared.stop()
    }
}

