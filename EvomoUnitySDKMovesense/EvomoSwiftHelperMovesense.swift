//
//  EvomoSwiftHelper.swift
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//

import Foundation
import EvomoMotionAIMovesense
import SwiftyJSON

@objc public class EvomoSwiftHelperMovesense: NSObject {
    
    enum MessageStatusCode:Int {
        case started = 0
        case connected = 1
        case stopped = 2
        case error = 3
        case movesenseDeviceFound = 4
        case noMovesenseDevice = 5
    }
    
    @objc public static func initEvomo(licenseID: String, debugging: Bool = true) {
        
        // set licenseID
        ClassificationControlLayerMovesense.shared.setLicense(licenseID: licenseID)
        
        // TODO: replace this static property with a unity controlled property
        ClassificationControlLayerMovesense.shared.debugging = false
        
        // optional input: debugging
        if debugging {
            ClassificationControlLayerMovesense.shared.setupLogging(logLevel: .debug)
        }
    }
    
    @objc public static func scanForMovesense(unityBridge: EvomounityBridgeMovesense) {
        ClassificationControlLayerMovesense.shared.scanForMovesense() { deviceIdent in
            
            var statusCode: MessageStatusCode = .noMovesenseDevice
            
            if let deviceIdent = deviceIdent {
                print("EvomoUnityBridge - MovesenseDevice found \(deviceIdent)")
                statusCode = .movesenseDeviceFound
            }
            
            unityBridge.sendMessage(
                JSON(["deviceID": "gobal",
                      "message": ["statusCode": statusCode.rawValue,
                        "data": deviceIdent ?? ""]
                ]).rawString()
            )
        }
    }
    
    @objc public static func startEvomo(unityBridge: EvomounityBridgeMovesense,
                                        deviceOrientation: String,
                                        deviceType: String = "Movesense",
                                        deviceId: String = "",
                                        classificationModel: String,
                                        gaming: Bool = true) {
        
        // Subscribe movements
        ClassificationControlLayerMovesense.shared.gaming = gaming
        
        var cModel = classificationModel
        
        if gaming {
            
            if cModel == "" {
                cModel = "subway-surfer"
            }
            
            ClassificationControlLayerMovesense.shared.elementalMovementHandler = { elementalMovement in
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
            ClassificationControlLayerMovesense.shared.movementHandler = { movement in
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
        let deviceMovesense = Device(deviceID: deviceId, deviceType: .movesense, devicePosition: .chest,
                                     deviceOrientation: devOrientation, classificationModel: cModel)
        
        print("EvomoUnityBridge: Start with config - orientation: \(deviceOrientation), model: \(cModel)")
        
        // Start
        ClassificationControlLayerMovesense.shared.start(devices: [deviceMovesense], isConnected: {
            print("MovesenseIsConnected")
            unityBridge.sendMessage(
                JSON(["deviceID": "gobal",
                      "message": ["statusCode": MessageStatusCode.connected.rawValue]
                ]).rawString()
            )
        })
    }
    
    @objc public static func stopEvomo() {
        //        let unityBridge: EvomounityBridge = EvomounityBridge()
        
        // TODO: Unity messages deactivated because of problems in gamehub usage
        // Could be solved in unity plugin by waiting on Destroy for stop message
        ClassificationControlLayerMovesense.shared.stop().done { _ in
            //            unityBridge.sendMessage(
            //                JSON(["deviceID": "gobal",
            //                      "message": ["statusCode": MessageStatusCode.stopped.rawValue]]).rawString()
            //            )
            print("Unity-Bridge: stopped")
        }.catch { error in
            print("Unity-Bridge: Error \(error)")
            //            unityBridge.sendMessage(
            //                JSON(["deviceID": "gobal",
            //                      "message": ["statusCode": MessageStatusCode.error.rawValue,
            //                                  "data": error]]).rawString()
            //            )
        }
    }
    
    
    @objc public static func logEvent(eventType: String, note: String?) {
        ClassificationControlLayerMovesense.shared.logEvent(eventType: eventType, note: eventType)
    }
    
    @objc public static func logTargetMovement(movementType: String, note: String?) {
        ClassificationControlLayerMovesense.shared.logTargetMovement(movementType: movementType, note: nil)
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
        
        ClassificationControlLayerMovesense.shared.logFailure(source: sourceEnum, failureType: failureTypeEnum, movementType: movementType, note: note)
    }
    
    @objc public static func setUsername(_ username: String) {
        ClassificationControlLayerMovesense.shared.setUsername(username)
    }
    
    @objc public static func sendUnityMessage(_ message: String) {
        
        //        send message from unit to client (such as gamehub)
        if let messageHandler = ClassificationControlLayerMovesense.shared.unityToNativeMessageHandler {
            messageHandler(message)
        }
        
    }
}
