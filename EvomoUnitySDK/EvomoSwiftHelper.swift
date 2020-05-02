//
//  EvomoSwiftHelper.swift
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//

import Foundation
import EvomoMotionAI


@objc public class EvomoSwiftHelper: NSObject {
    
    @objc public static func initEvomo(unityBridge : EvomounityBridge) {
        
        ClassificationControlLayer.shared.elementalMovementHandler = { elementalMovement in
            if !elementalMovement.rejected {
                let gameEvent: String?
                switch(elementalMovement.typeLabel) {
                case "hop_single_straight_up":
                    gameEvent = "jump"
                    unityBridge.jump()
                case "duck down":
                    gameEvent = "duck"
                    unityBridge.duck()
                case "side_step_left_up":
                    gameEvent = "left"
                    unityBridge.left()
                case "side_step_right_up":
                    gameEvent = "right"
                    unityBridge.right()
                default:
                    gameEvent = nil
                }
                if gameEvent != nil {
                    print(gameEvent! + " ID:" + String( elementalMovement.typeID))
                }
            }
        }        
    }
    
    @objc public static func startEvomo() {
       let deviceIphone = Device(deviceID: "", deviceType: .iPhone, devicePosition: .hand, deviceOrientation: .buttonDown,
                                 classificationModel: "2057")
       
        ClassificationControlLayer.shared.gaming = true

        ClassificationControlLayer.shared.start(
              devices: [deviceIphone],
              licenseID: "143ab59d-c267-4dde-aa0d-c2314df72e81",
              isStarted: {
                  print("Evomo Startead!")
                  
          },
              isFailed: {error in print("\(error)")}
          )
   }
    
    @objc public static func stopEvomo() {
        ClassificationControlLayer.shared.stop()
    }
}

