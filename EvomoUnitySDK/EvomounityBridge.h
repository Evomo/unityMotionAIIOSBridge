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

typedef void (*UnityCallback)(int data);

- (void) Init: (UnityCallback) callback licenseID: (NSString *) licenseID;
- (void) Init: (NSString *) licenseID;

- (void) Start;
- (void) Stop;

- (void) LogEvent: (NSString *)eventType note: (NSString *) note;
- (void) LogEvent: (NSString *)eventType;

- (void) LogTargetMovement: (NSString *)eventType;
- (void) LogTargetMovement: (NSString *)eventType note: (NSString *) note;

- (void) LogFailure:(NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType
               note: (NSString *) note;

- (void) LogFailure:(NSString *) source
        failureType: (NSString *) failureType
       movementType: (NSString *) movementType;

- (void) Ready;
- (void) Jump;
- (void) Duck;
- (void) Left;
- (void) Right;

@end
#endif /* EvomounityBridge_h */
