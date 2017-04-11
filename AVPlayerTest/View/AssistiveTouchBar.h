//
//  AssistiveTouchBar.h
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/30.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistiveTouchBar : UIImageView

@property(nonatomic,copy) void(^clickTouch)();
@property(nonatomic) BOOL userTouchEnabled;

@end
