//
//  EvomoUnity.m
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//
#import <Foundation/Foundation.h>
#if __has_include("EvomoUnitySDK-Swift.h")
    #import "EvomoUnitySDK-Swift.h"
#else
    #import <EvomoUnitySDK/EvomoUnitySDK-Swift.h>
#endif
#import "EvomounityBridge.h"


@implementation EvomounityBridge

static UnityCallback _callback;

- (void) Init: (UnityCallback) callback licenseID: (NSString *) licenseID debugging: (Boolean) debugging {
    _callback = callback;
    [EvomoSwiftHelper initEvomoWithLicenseID:licenseID debugging:debugging];
}

- (void) Start: (NSString *) deviceOrientation classificationModel: (NSString *) classificationModel gaming: (Boolean) gaming {
    [EvomoSwiftHelper startEvomoWithUnityBridge:self deviceOrientation:deviceOrientation classificationModel: classificationModel gaming:gaming];
}

- (void) LogEvent: (NSString *)eventType note: (NSString *)note {
    [EvomoSwiftHelper logEventWithEventType:eventType note:note];
}

- (void) LogTargetMovement: (NSString *)movementType  note: (NSString *)note {
    [EvomoSwiftHelper logTargetMovementWithMovementType:movementType note:note];
}

- (void) LogFailure: (NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType
               note: (NSString *) note {
    
    [EvomoSwiftHelper logFailureWithSource:source
                               failureType:failureType
                              movementType:movementType
                                      note:note];
}

- (void) SetUsername: (NSString *) username {
    [EvomoSwiftHelper setUsername:username];
}

- (void) Stop {
  [EvomoSwiftHelper stopEvomo];
}

- (void) SendMessage: (NSString *) message {
    _callback(message);
}

@end

