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

- (void) Init: (UnityCallback) callback;

- (void) Start;

- (void) Stop;


- (void) Ready;
- (void) Jump;
- (void) Duck;
- (void) Left;
- (void) Right;

@end
#endif /* EvomounityBridge_h */
