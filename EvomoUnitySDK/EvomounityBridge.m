//
//  EvomoUnity.m
//  EvomoUnityBridge
//
//  Created by Richard Elms on 19/03/2020.
//  Copyright © 2020 richardelms. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <EvomoUnitySDK/EvomoUnitySDK-Swift.h>
#import "EvomounityBridge.h"


@implementation EvomounityBridge

static UnityCallback _callback;

- (void) Init: (UnityCallback) callback {
    _callback = callback;
  [EvomoSwiftHelper initEvomoWithUnityBridge:self];
    [self Ready];
}

- (void) Start {
  [EvomoSwiftHelper startEvomo];
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

