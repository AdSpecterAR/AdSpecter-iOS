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

    typedef const void *ASRLoaderRef;

    void set_developer_key(const char *developerKey);

    void ASRAdWasTapped(ASRLoaderRef ref);

    ASRLoaderRef ASRCreateLoader(float width, float height);

    void ASRSetDeveloperKey(const char *developerKey);

#ifdef __cplusplus
}
#endif
