//
//  EvomounityBridge.h
//  Unity-iPhone
//
//  Created by Richard Elms on 10/04/2020.
//

#ifndef EvomounityBridge_h
#define EvomounityBridge_h


#import <Foundation/Foundation.h>

@interface EvomounityBridge : NSObject

typedef void (*ReadyCallback)(void);
typedef void (*StoppedCallback)(void);
typedef void (*ElmoCallback)(NSString * data);
typedef void (*MovementCallback)(NSString * data);


- (void) Init: (ReadyCallback) callback licenseID: (NSString *) licenseID debugging: (Boolean) debugging;

- (void) SubscribeElmos: (ElmoCallback) callback;

- (void) SubscribeMovements: (MovementCallback) callback;

- (void) Start: (NSString *) deviceOrientation classificationModel: (NSString *) classificationModel;
- (void) Stop;
// Add callback to stop for uploading debugging data

- (void) LogEvent: (NSString *) eventType note: (NSString *) note;

- (void) LogTargetMovement: (NSString *) eventType note: (NSString *) note;

- (void) LogFailure: (NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType
               note: (NSString *) note;

- (void) SetUsername: (NSString *) username;

- (void) Ready;
- (void) SendElmo: (NSString *) elmoStr;
- (void) SendMovement: (NSString *) movementStr;

@end
#endif /* EvomounityBridge_h */
