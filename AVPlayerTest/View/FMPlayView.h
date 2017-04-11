//
//  FMPlayView.h
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/6.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPlayView : UIView
@property (nonatomic, weak) UILabel *playTime;
@property (nonatomic, weak) UILabel *playCurrentTime;
@property (nonatomic, weak) UIButton *play;
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIActivityIndicatorView *act;
@property (nonatomic, copy) void(^clickPlay)(BOOL selected);
@property (nonatomic, copy) void(^closeDetail)();
@property (nonatomic, copy) void(^previousBlock)();
@property (nonatomic, copy) void(^nextBlock)();
@property (nonatomic, copy) void(^showList)();
@end
