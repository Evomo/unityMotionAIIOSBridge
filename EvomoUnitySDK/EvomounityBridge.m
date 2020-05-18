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

- (void) Init: (UnityCallback) callback licenseID: (NSString *) licenseID {
    _callback = callback;
  [EvomoSwiftHelper initEvomoWithUnityBridge:self licenseID:licenseID];
    [self Ready];
}

- (void) Start: (NSString *) deviceOrientation classificationModel: (NSString *) classificationModel {
    [EvomoSwiftHelper startEvomoWithDeviceOrientation:deviceOrientation classificationModel:classificationModel];
}

- (void) LogEvent: (NSString *)eventType note: (NSString *)note {
    [EvomoSwiftHelper logEventWithEventType:eventType note:note];
}

- (void) LogTargetMovement: (NSString *)movementType  note: (NSString *)note {
    [EvomoSwiftHelper logTargetMovementWithMovementType:movementType note:note];
}

- (void) LogFailure:(NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType
               note: (NSString *) note {
    
    [EvomoSwiftHelper logFailureWithSource:source
                               failureType:failureType
                              movementType:movementType
                                      note:note];
}

- (void) Stop {
  [EvomoSwiftHelper stopEvomo];
}

- (void) Ready {
    _callback(0);
}

- (void) Jump {
    _callback(1);
}

- (void) Duck {
    _callback(2);
}

- (void) Left {
    _callback(3);
}

- (void) Right {
    _callback(4);
}

@end

