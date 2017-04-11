//
//  AppDelegate.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/3.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[MainTabController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    self.touchBar = [[AssistiveTouchBar alloc]initWithFrame:CGRectMake(0, 64, 50, 50)];
    self.touchBar.clickTouch = ^(){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modalMusicDetail" object:nil];
    };
    self.touchBar.userTouchEnabled = YES;
    [self.window addSubview:self.touchBar];

    return YES;
}



@end
