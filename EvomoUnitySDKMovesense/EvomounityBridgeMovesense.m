//
//  EvomoUnity.m
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//
#import <Foundation/Foundation.h>
#if __has_include("EvomoUnitySDKMovesense-Swift.h")
    #import "EvomoUnitySDKMovesense-Swift.h"
#else
    #import <EvomoUnitySDKMovesense/EvomoUnitySDKMovesense-Swift.h>
#endif
#import "EvomounityBridgeMovesense.h"


@implementation EvomounityBridgeMovesense

static UnityCallback _callback;

- (void) Init: (UnityCallback) callback {
    _callback = callback;
  [EvomoSwiftHelperMovesense initEvomoWithUnityBridge:self];
    [self Ready];
}

- (void) Start {
  [EvomoSwiftHelperMovesense startEvomo];
}

- (void) Stop {
  [EvomoSwiftHelperMovesense stopEvomo];
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

