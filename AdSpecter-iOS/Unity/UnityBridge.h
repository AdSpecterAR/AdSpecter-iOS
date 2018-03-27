//
//  UnityBridge.h
//  AdSpecter-iOS
//
//  Created by Adam Proschek on 3/6/18.
//  Copyright © 2018 John Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASRTypes.h"

#ifdef __cplusplus
extern "C" {
#endif
    typedef const void *ASRUnityAdLoaderRef;
    typedef const void (*ASRAdLoaderImageLoadedHandler) (ASRUnityAdLoaderRef ref, const char *data);

    void ASRSetDeveloperKey(const char *developerKey);

    ASRUnityAdLoaderRef ASRCreateLoader(ASRAdLoaderImageLoadedHandler handler);

    void ASRAdWasTapped(ASRUnityAdLoaderRef ref);
    void ASRSetAdLoaderImageLoadedHandler(ASRUnityAdLoaderRef ref, ASRAdLoaderImageLoadedHandler handler);

#ifdef __cplusplus
}
#endif
