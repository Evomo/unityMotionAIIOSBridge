//
//  EvomounityBridge.h
//  Unity-iPhone
//
//  Created by Richard Elms on 10/04/2020.
//

#ifndef EvomounityBridgeMovesense_h
#define EvomounityBridgeMovesense_h


#import <Foundation/Foundation.h>

@interface EvomounityBridgeMovesense : NSObject

typedef void (*UnityCallback)(const char *);

- (void) Init: (UnityCallback) callback licenseID: (NSString *) licenseID debugging: (Boolean) debugging;

- (void) Start: (NSString *) deviceOrientation deviceType: (NSString *) deviceType classificationModel: (NSString *) classificationModel gaming: (Boolean) gaming licenseID: (NSString *) licenseID;

- (void) Stop;

- (void) LogEvent: (NSString *) eventType note: (NSString *) note;

- (void) LogTargetMovement: (NSString *) eventType note: (NSString *) note;

- (void) LogFailure: (NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType
               note: (NSString *) note;

- (void) SetUsername: (NSString *) username;

- (void) SendMessage: (const char *) message;

- (void) SendGameHubMessage: (NSString *) message;

@end
#endif /* EvomounityBridgeMovesense_h */
