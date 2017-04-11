//
//  PlayerManagerTool.h
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/27.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerManagerTool : NSObject

@property (nonatomic, strong) AVQueuePlayer *player;

@property (nonatomic) BOOL isPrepare;  //是否有准备播放的音乐

@property (nonatomic) BOOL isPlay;     //是否正在播放音乐

@property (nonatomic) BOOL isMusicPlaying; //是否音乐已经开始播放出来

@property (nonatomic, assign) NSInteger index; //音乐索引

+ (instancetype)sharedInstance;

- (void)preparePlayMusicWithIndex:(NSInteger)index;

- (void)playMusic;

- (void)previousMusic;  //上一首

- (void)nextMusic;      //下一首

- (void)releasePlayer;  //清空所有属性

@end
