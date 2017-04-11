//
//  PlayerManagerTool.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/27.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "PlayerManagerTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerManagerTool()
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

static PlayerManagerTool *instance = nil;

@implementation PlayerManagerTool{
    id _timeObserve;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [self loadAllItems];
    }
    return self;
}

- (void)loadAllItems{
    self.index = 0;
    self.sourceArray = @[].mutableCopy;
    self.itemArray = @[].mutableCopy;
    [self.sourceArray addObject:@"http://rzd.oss-cn-shanghai.aliyuncs.com/test/%E6%9D%A8%E5%AE%97%E7%BA%AC%E3%80%81%E5%BC%A0%E7%A2%A7%E6%99%A8%20-%20%E5%87%89%E5%87%89.mp3"];
    [self.sourceArray addObject:@"http://rzd.oss-cn-shanghai.aliyuncs.com/test/%E8%B5%B5%E8%8B%B1%E4%BF%8A%20-%20%E5%A4%A7%E7%8E%8B%E5%8F%AB%E6%88%91%E6%9D%A5%E5%B7%A1%E5%B1%B1.mp3"];
    [self.sourceArray addObject:@"http://rzd.oss-cn-shanghai.aliyuncs.com/test/%E9%A1%BE%E8%8E%89%E9%9B%85%20-%20%E5%AF%82%E5%AF%9E%E8%8A%B1%E7%81%AB.mp3"];
}

#pragma mark - 核心创建AV
- (void)preparePlayMusicWithIndex:(NSInteger)index{
    self.index = index;
    [self.itemArray removeAllObjects];
    for (int i = 0; i < self.sourceArray.count; i++) {
        NSURL *musicURL = [NSURL URLWithString:self.sourceArray[i]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:musicURL];
        [self.itemArray addObject:item];
    }
    
    _player = [[AVQueuePlayer alloc]initWithItems:self.itemArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
//    [_player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    if (_player && _player.currentItem) {
        self.isPrepare = YES;
    }else{
        self.isPrepare = NO;
    }
}

#pragma makr - 播放与暂停
- (void)playMusic{
    if (!_isPlay) {
        _isPlay = YES;
        [_player play];
    }else{
        _isPlay = NO;
        [_player pause];
    }
    [self addMusicTimeMake];
    self.isMusicPlaying = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeChannel" object:@(self.isMusicPlaying)];
}

#pragma mark 上一首
- (void)previousMusic{
    self.index--;
    [self playAtIndex:self.index];
}

#pragma mark - 切换顺序，用来播放上一首
- (void)playAtIndex:(NSInteger)index{
    [[NSNotificationCenter defaultCenter] removeObserver:self.player.currentItem];
    [self.player removeAllItems];
    for (NSInteger i = index; i <self.itemArray.count; i ++) {
        AVPlayerItem* obj = [self.itemArray objectAtIndex:i];
        if ([self.player canInsertItem:obj afterItem:nil]) {
            [obj seekToTime:kCMTimeZero];
            [self.player insertItem:obj afterItem:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - 下一首
- (void)nextMusic{
    [[NSNotificationCenter defaultCenter] removeObserver:self.player.currentItem];
    self.index++;
    [self.player advanceToNextItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


-(void)addMusicTimeMake{
    __weak PlayerManagerTool *weakSelf = self;
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weakSelf updateLockedScreenMusic];//控制中心
        weakSelf.isMusicPlaying = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeChannel" object:@(weakSelf.isMusicPlaying)];
    }];
}

/** 监控播放状态 */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    AVPlayerItem *playerItem = (AVPlayerItem *)object;
//    if ([keyPath isEqualToString:@"status"]) {
//        NSLog(@"当前状态——%ld",(long)playerItem.status);
//    }
//}

- (void)playbackFinished:(NSNotification *)sender{
    NSLog(@"播放结束");
}

#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"什么？";
    // 歌手
    info[MPMediaItemPropertyArtist] = @"歌手";
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = @"擦擦擦擦擦擦擦？";
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"backImageView"]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    // 切换播放信息
    center.nowPlayingInfo = info;
}

//清空播放器监听属性
- (void)releasePlayer{
    if (!self.player.currentItem) return;
//    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_timeObserve];
    _timeObserve = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
}

@end
