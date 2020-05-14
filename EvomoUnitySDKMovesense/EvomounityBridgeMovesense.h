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
#endif /* EvomounityBridgeMovesense_h */
