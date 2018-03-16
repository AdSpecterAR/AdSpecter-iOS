//
//  UnityBridge.mm
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/6/18.
//  Copyright © 2018 John Li. All rights reserved.
//

#import "UnityBridge.h"
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import "ASRTypes.h"
#import <AdSpecter_iOS/AdSpecter_iOS-Swift.h>

void set_developer_key(const char *developerKey) {
    NSLog(@"ORIGINAL SET DEVELOPER KEY: %@", [NSString stringWithUTF8String:developerKey]);
    [[AdSpecter shared] setDeveloperKey:[NSString stringWithUTF8String:developerKey]];
}

ASRLoaderRef ASRCreateLoader(float width, float height) {
    NSLog(@"\n\nAd was created\n");
    ASRAdLoader *loader = [[ASRAdLoader alloc] init];
    CGSize size = CGSizeMake(width, height);
    loader.maxSizeDimensions = size;
    return (__bridge ASRLoaderRef)loader;
}

void ASRAdWasTapped(ASRLoaderRef ref) {
    NSLog(@"\n\nAd was tapped!\n");
}

void ASRSetDeveloperKey(const char *key) {
    NSString *developerKey = [NSString stringWithUTF8String:key];
    NSLog(@"Printing developer key: %@", developerKey);
    [[AdSpecter shared] setDeveloperKey:developerKey];
}
