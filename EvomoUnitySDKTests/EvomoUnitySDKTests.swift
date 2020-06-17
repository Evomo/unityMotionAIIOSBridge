//
//  EvomoUnitySDKTests.swift
//  EvomoUnitySDKTests
//
//  Created by Jakob Wowy on 15.06.20.
//  Copyright © 2020 evomo. All rights reserved.
//

import XCTest
import EvomoMotionAI


class EvomoUnitySDKTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
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
        
        ClassificationControlLayer.shared.setupLogging(logLevel: .debug)
        
        ClassificationControlLayer.shared.gaming = true
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
