//
//  ASRUnityAdLoader.h
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/20/18.
//  Copyright © 2018 John Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnityBridge.h"

@interface ASRUnityAdLoader : NSObject

@property (nonatomic, assign) ASRAdLoaderImageLoadedHandler imageLoadedHandler;

- (instancetype)initWithImageLoadHandler:(ASRAdLoaderImageLoadedHandler)imageLoadedHandler;

- (void)adWasTapped;

@end
