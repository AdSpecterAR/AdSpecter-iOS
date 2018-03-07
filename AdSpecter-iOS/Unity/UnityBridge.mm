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
#import <AdSpecter_iOS/AdSpecter_iOS-Swift.h>

void set_developer_key(const char *developerKey) {
    [[AdSpecter shared] setDeveloperKey:[NSString stringWithUTF8String:developerKey]];
}
