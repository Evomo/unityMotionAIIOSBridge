//
//  EvomoSwiftHelper.swift
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//

import Foundation
import EvomoMotionAI
import SwiftyJSON

//let licenseID = "800ff7ea-521b-4d5f-b1f9-c04e90d665fa"

@objc public class EvomoSwiftHelper: NSObject {
        
    @objc public static func initEvomo(unityBridge : EvomounityBridge, licenseID: String, debugging: Bool = true) {
        
        // set licenseID
        ClassificationControlLayer.shared.setLicense(licenseID: licenseID)
        
        // optional input: debugging
        ClassificationControlLayer.shared.debugging = debugging
        if debugging {
            ClassificationControlLayer.shared.setupLogging(logLevel: .debug)
        }
    }
    
    @objc public static func subcribeElmos(unityBridge : EvomounityBridge) {
        
        ClassificationControlLayer.shared.gaming = true
        
        let unityBridge: EvomounityBridge = EvomounityBridge()
        
        ClassificationControlLayer.shared.elementalMovementHandler = { elementalMovement in
            // Send elmo to unity
            
            unityBridge.sendElmo(JSON(elementalMovement.serializeCompact()).rawString())
        }
    }
    
    @objc public static func subcribeMovements(unityBridge : EvomounityBridge) {
        
        ClassificationControlLayer.shared.gaming = false
        
          let unityBridge: EvomounityBridge = EvomounityBridge()
          
          ClassificationControlLayer.shared.movementHandler = { movement in
              // Send movement to unity
              
            unityBridge.sendMovement(JSON(movement.serializeCompact()).rawString())
          }
      }
    
    @objc public static func startEvomo(deviceOrientation: String, classificationModel: String) {
        
        // Convert deviceOrientation string to enum
        let devOrientation: DeviceOrientation
        switch deviceOrientation {
        case "buttonRight":
            devOrientation = .buttonRight
        case "buttonLeft":
            devOrientation = .buttonLeft
        case "buttonDown":
            devOrientation = .buttonDown
        default:
            devOrientation = .buttonDown
            print("Warning: Conversion of device orientation \(deviceOrientation) failed! Set to default of buttonDown")
        }
        
        
        // Define device
        let deviceIphone = Device(deviceID: "", deviceType: .iPhone, devicePosition: .hand,
                                  deviceOrientation: devOrientation, classificationModel: classificationModel)
        
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
    
    @objc public static func setUsername(_ username: String) {
        ClassificationControlLayer.shared.setUsername(username)
    }
    
    
}
