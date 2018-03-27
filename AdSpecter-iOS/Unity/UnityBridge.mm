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
#import "ASRUnityAdLoader.h"

void ASRSetDeveloperKey(const char *key) {
    NSString *developerKey = [NSString stringWithUTF8String:key];
    NSLog(@"Printing developer key: %@", developerKey);
    [[AdSpecter shared] setDeveloperKey:developerKey];
}

ASRUnityAdLoaderRef ASRCreateLoader(ASRAdLoaderImageLoadedHandler handler) {
    NSLog(@"\n\nAd was created\n");
    ASRUnityAdLoader *loader = [[ASRUnityAdLoader alloc] initWithImageLoadHandler:handler];
    return (__bridge ASRUnityAdLoaderRef)loader;
}

void ASRAdWasTapped(ASRUnityAdLoaderRef ref) {
    ASRUnityAdLoader *loader = (__bridge ASRUnityAdLoader *)ref;
    [loader adWasTapped];
}

void ASRSetAdLoaderImageLoadedHandler(ASRUnityAdLoaderRef ref, ASRAdLoaderImageLoadedHandler handler) {
    ASRUnityAdLoader *loader = (__bridge ASRUnityAdLoader *)ref;
    loader.imageLoadedHandler = handler;
}
