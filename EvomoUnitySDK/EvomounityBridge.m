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

static ReadyCallback _readyCallback;
static StoppedCallback _stoppedCallback;
static ElmoCallback _elmoCallback;
static MovementCallback _movementCallback;

- (void) Init: (ReadyCallback) callback licenseID: (NSString *) licenseID debugging: (Boolean) debugging {
    _readyCallback = callback;
    [EvomoSwiftHelper initEvomoWithUnityBridge:self licenseID:licenseID debugging:debugging];
//    [self Ready];
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

- (void) SendReadySiganl {
    _readyCallback();
}

- (void) SendStoppedSignal {
    _stoppedCallback();
}

- (void) SendElmo: (NSString *) elmoStr {
    _elmoCallback(elmoStr);
}

- (void) SendMovement: (NSString *) movementStr {
    _movementCallback(movementStr);
}

@end

