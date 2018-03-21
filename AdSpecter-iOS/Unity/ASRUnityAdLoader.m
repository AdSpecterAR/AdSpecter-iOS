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

- (void)adLoader:(ASRAdLoader * _Nonnull)loader didLoad:(UIImage * _Nonnull)image {
    NSLog(@"DID LOAD IMAGE");
    if (self.imageLoadedHandler == nil || image == nil) {
        return;
    }

    NSLog(@"HAS HANDLER AND IMAGE");
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    self.imageLoadedHandler((__bridge ASRUnityAdLoaderRef)self, [data bytes]);
}

@end
