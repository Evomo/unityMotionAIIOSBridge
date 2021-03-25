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
    #import <EvomoUnitySDKMovesense/EvomoUnitySDKMovesense-Swift.h>
#endif
#import "EvomounityBridgeMovesense.h"


@implementation EvomounityBridgeMovesense

static UnityCallback _callback;

- (void) Init: (UnityCallback) callback licenseID: (NSString *) licenseID debugging: (Boolean) debugging {
    _callback = callback;
    [EvomoSwiftHelperMovesense initEvomoWithLicenseID:licenseID debugging:debugging];
}

- (void) Start: (NSString *) deviceOrientation classificationModel: (NSString *) classificationModel gaming: (Boolean) gaming {
    [EvomoSwiftHelperMovesense startEvomoWithUnityBridge:self deviceOrientation:deviceOrientation classificationModel: classificationModel gaming:gaming];
}

- (void) LogEvent: (NSString *)eventType note: (NSString *)note {
    [EvomoSwiftHelperMovesense logEventWithEventType:eventType note:note];
}

- (void) LogTargetMovement: (NSString *)movementType  note: (NSString *)note {
    [EvomoSwiftHelperMovesense logTargetMovementWithMovementType:movementType note:note];
}

- (void) LogFailure: (NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementTypeco
               note: (NSString *) note {
    
    [EvomoSwiftHelperMovesense logFailureWithSource:source
                               failureType:failureType
                              movementType:movementType
                                      note:note];
}

- (void) SetUsername: (NSString *) username {
    [EvomoSwiftHelperMovesense setUsername:username];
}

- (void) Stop {
  [EvomoSwiftHelperMovesense stopEvomo];
}

- (void) SendMessage: (const char *) message {
    _callback((@"%s", message));
}

- (void) SendGameHubMessage: (NSString *) message {
    [EvomoSwiftHelperMovesense sendUnityMessage: message];
    
}

@end

