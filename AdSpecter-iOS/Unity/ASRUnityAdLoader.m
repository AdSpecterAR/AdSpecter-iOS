//
//  ASRUnityAdLoader.m
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/20/18.
//  Copyright © 2018 John Li. All rights reserved.
//

#import "ASRUnityAdLoader.h"
#import <AdSpecter_iOS/AdSpecter_iOS-Swift.h>

@interface ASRUnityAdLoader() <ASRAdLoaderDelegate>

@property (nonatomic, strong) ASRAdLoader *adLoader;

@end

@implementation ASRUnityAdLoader

- (instancetype)initWithImageLoadHandler:(ASRAdLoaderImageLoadedHandler)imageLoadedHandler {
    self = [self init];
    if (self) {
        _imageLoadedHandler = imageLoadedHandler;
        _adLoader = [[ASRAdLoader alloc] initWithDelegate:self];
        _adLoader.delegate = self;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Designated initializer
    }
    return self;
}

- (void)adWasTapped {
#warning Implement this
    NSLog(@"AD WAS TAPPED");
}

- (void)adLoaderDidUpdate:(ASRAdLoader *)loader {
#warning Implement this
}

@end
