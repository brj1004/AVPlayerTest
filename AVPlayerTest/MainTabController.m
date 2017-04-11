//
//  MainTabController.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/6.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "MainTabController.h"
#import "FMController.h"
#import "MusicController.h"
#import "MusicDetailController.h"
#import "PlayerManagerTool.h"

#import "AssistiveTouchBar.h"

@interface MainTabController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) MusicDetailController *controller;
@end

@implementation MainTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    MusicController *item0 = [[MusicController alloc]init];
    [self controller:item0 title:@"音乐" image:@"" selectedimage:@""];
    FMController *item1 = [[FMController alloc]init];
    [self controller:item1 title:@"暂无" image:@"" selectedimage:@""];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    //设置tabbar的颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    //设置tabbaritem被选中时的颜色
    self.tabBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    [self setSelectedIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modalMusicController:) name:@"modalMusicDetail" object:nil];
}

//初始化一个zi控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    nav.delegate = self;
    nav.tabBarItem.title = title;
    [self addChildViewController:nav];
}

- (void)modalMusicController:(NSNotification *)sender{
    if (!self.controller) {
        self.controller = [[MusicDetailController alloc] init];
    }
    NSNumber *number = sender.object;
    [self presentViewController:self.controller animated:YES completion:^{
        if (!number) {
            return;
        }
        if ([PlayerManagerTool sharedInstance].isPrepare) {
            if ([PlayerManagerTool sharedInstance].index != number.integerValue) {
                //外界切换主频道  需要重新创建AVPlayer
                self.controller.playView.play.selected = NO;
                [PlayerManagerTool sharedInstance].isPlay = NO;
                [PlayerManagerTool sharedInstance].isMusicPlaying = NO;
                [[PlayerManagerTool sharedInstance] releasePlayer];
                [[PlayerManagerTool sharedInstance] preparePlayMusicWithIndex:number.integerValue];
            }
        }else{
            [[PlayerManagerTool sharedInstance] preparePlayMusicWithIndex:number.integerValue];
        }
    }];
}

#pragma mark - 远程控制事件监听
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - 锁屏状态接收点击效果
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [[PlayerManagerTool sharedInstance] playMusic];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [[PlayerManagerTool sharedInstance] nextMusic];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[PlayerManagerTool sharedInstance] previousMusic];
        default:
            break;
    }
}

- (void)dealloc {
    // 关闭消息中心
    [[PlayerManagerTool sharedInstance] releasePlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
