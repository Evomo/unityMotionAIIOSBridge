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
            
    enum MessageStatusCode:Int {
        case started = 0
        case connected = 1
        case stopped = 2
        case error = 3
    }
    
    @objc public static func initEvomo(licenseID: String, debugging: Bool = true) {
        
        // set licenseID
        ClassificationControlLayer.shared.setLicense(licenseID: licenseID)
        
        // optional input: debugging
        ClassificationControlLayer.shared.debugging = debugging
        if debugging {
            ClassificationControlLayer.shared.setupLogging(logLevel: .debug)
        }
    }
        
    @objc public static func startEvomo(unityBridge: EvomounityBridge,
                                        deviceOrientation: String,
                                        classificationModel: String,
                                        gaming: Bool = true) {
        
        // Subscribe movements
        ClassificationControlLayer.shared.gaming = gaming
        
        var cModel = classificationModel
        
        if gaming {
            
            if cModel == "" {
                cModel = "subway-surfer"
            }
            
            ClassificationControlLayer.shared.elementalMovementHandler = { elementalMovement in
                // Send elmo to unity
                
                if elementalMovement.typeLabel != "unknown" {
                    // Convert elmo name (because of changes in the django_backend)
                    var jsonStr: String = JSON(["deviceID": elementalMovement.device.ident, "elmo": elementalMovement.serializeCompact()]).rawString()!
                    
                    jsonStr = jsonStr.replacingOccurrences(of: "duck down", with: "duck_down")
                        .replacingOccurrences(of: "duck up", with: "duck_up")
                        .replacingOccurrences(of: "hop_group_up", with: "hop_single_up")
                        .replacingOccurrences(of: "hop_group_down", with: "hop_single_down")
                    unityBridge.sendMessage(jsonStr)
                }
            }
            
        } else {
            ClassificationControlLayer.shared.movementHandler = { movement in
                // Send movement to unity
                
                unityBridge.sendMessage(
                    JSON(["deviceID": movement.elmos.first!.device.ident, "movement": movement.serializeCompact()]).rawString()
                )
            }
        }
        
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
            print("EvomoUnityBridge - Warning: Conversion of device orientation \(deviceOrientation) failed! Set to default of buttonDown")
        }
        
        // Define device
        let deviceIphone = Device(deviceID: "", deviceType: .iPhone, devicePosition: .hand,
                                  deviceOrientation: devOrientation, classificationModel: cModel)
        
        print("EvomoUnityBridge: Start with config - orientation: \(deviceOrientation), model: \(cModel)")
        
        // Start
        ClassificationControlLayer.shared.start(
            devices: [deviceIphone],
            licenseID: nil,
            isConnected: {
                unityBridge.sendMessage(
                    JSON(["deviceID": "gobal",
                          "message": ["statusCode": MessageStatusCode.connected.rawValue]]).rawString()
                )
        }, isStarted: {
            unityBridge.sendMessage(
                JSON(["deviceID": "gobal",
                      "message": ["statusCode": MessageStatusCode.started.rawValue]]).rawString()
            )
            
        },isFailed: { error in
                
                unityBridge.sendMessage(
                    JSON(["deviceID": "gobal",
                          "message": ["statusCode": MessageStatusCode.error.rawValue,
                                      "data": error]]).rawString()
                )
                print("EvomoUnityBridge - startClassificationError:  \(error)")
                
        })
    }
    
    @objc public static func stopEvomo() {
        let unityBridge: EvomounityBridge = EvomounityBridge()
        
        ClassificationControlLayer.shared.stop().done { _ in
            unityBridge.sendMessage(
                JSON(["deviceID": "gobal",
                      "message": ["statusCode": MessageStatusCode.stopped.rawValue]]).rawString()
            )
        }.catch { error in
            unityBridge.sendMessage(
                JSON(["deviceID": "gobal",
                      "message": ["statusCode": MessageStatusCode.error.rawValue,
                                  "data": error]]).rawString()
            )
        }
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
    
    @objc public static func sendUnityMessage(_ message: String) {
        
//        send message from unit to client (such as gamehub)
        if let messageHandler = ClassificationControlLayer.shared.unityToNativeMessageHandler {
            messageHandler(message)
        }
    }
    
}
