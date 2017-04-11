//
//  FMPlayView.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/6.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "FMPlayView.h"
#import "Masonry.h"

@interface FMPlayView()
@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UIButton *close;
@property (nonatomic, weak) UIButton *previousPlay;
@property (nonatomic, weak) UIButton *nextPlay;
@property (nonatomic, weak) UIButton *showlistBtn;
@end

@implementation FMPlayView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self onCreate];
    }
    return self;
}

- (void)onCreate{
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.image = [UIImage imageNamed:@"backImageView"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    _backImageView = backImageView;
    
    UIButton *previousPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousPlay setImage:[UIImage imageNamed:@"上一集-icon"] forState:UIControlStateNormal];
    previousPlay.adjustsImageWhenHighlighted = NO;
    [previousPlay addTarget:self action:@selector(previousPlayItem) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:previousPlay];
    _previousPlay = previousPlay;
    
    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
    [play setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    play.adjustsImageWhenHighlighted = NO;
    [play addTarget:self action:@selector(playItem:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:play];
    _play = play;
    
    UIButton *nextPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPlay setImage:[UIImage imageNamed:@"下一集icon"] forState:UIControlStateNormal];
    nextPlay.adjustsImageWhenHighlighted = NO;
    [nextPlay addTarget:self action:@selector(nextPlayItem) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:nextPlay];
    _nextPlay = nextPlay;
    
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:[UIImage imageNamed:@"椭圆-1"] forState:UIControlStateNormal];
    slider.minimumTrackTintColor = [UIColor blueColor];
    slider.maximumTrackTintColor = [UIColor whiteColor];
    slider.continuous = YES;
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.value = 0.0;
    [_backImageView addSubview:slider];
    _slider = slider;
    
    UILabel *playTime = [UILabel new];
    playTime.text = @"00:00";
    playTime.font = [UIFont systemFontOfSize:12];
    playTime.textAlignment = NSTextAlignmentLeft;
    [_backImageView addSubview:playTime];
    _playTime = playTime;
    
    UILabel *playCurrentTime = [UILabel new];
    playCurrentTime.text = @"00:00";
    playCurrentTime.font = [UIFont systemFontOfSize:12];
    playCurrentTime.textAlignment = NSTextAlignmentRight;
    [_backImageView addSubview:playCurrentTime];
    _playCurrentTime = playCurrentTime;
    
    UIButton *showlistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showlistBtn setImage:[UIImage imageNamed:@"列表"] forState:UIControlStateNormal];
    showlistBtn.adjustsImageWhenHighlighted = NO;
    [showlistBtn addTarget:self action:@selector(showTableViewList) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:showlistBtn];
    _showlistBtn = showlistBtn;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
    [close setImage:[UIImage imageNamed:@"closeDetail"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePlay:) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:close];
    _close = close;
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    act.color = [UIColor whiteColor];       
    [self addSubview:act];
    _act = act;
}

- (void)playItem:(UIButton *)sender{
    sender.selected = !sender.selected;
    !self.clickPlay ? :self.clickPlay(sender.selected);
}

- (void)previousPlayItem{
    !self.previousBlock ? :self.previousBlock();
}

- (void)nextPlayItem{
    !self.nextBlock ? :self.nextBlock();
}

- (void)closePlay:(UIButton *)sender {
    !self.closeDetail ? :self.closeDetail();
}

- (void)showTableViewList{
    !self.showList ? :self.showList();
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _backImageView.frame = self.bounds;
    
    [_close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.width.and.height.mas_equalTo(40);
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(13);
    }];
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 1));
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-180);
    }];
    
    [_playTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(_slider.mas_bottom).offset(10);
    }];
    
    [_playCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(_slider.mas_bottom).offset(10);
    }];
    
    [_play mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.and.width.mas_equalTo(80);
        make.centerX.equalTo(_backImageView);
        make.top.mas_equalTo(_playTime.mas_bottom).offset(20);
    }];
    
    [_previousPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.and.width.mas_equalTo(80);
        make.top.mas_equalTo(_play).offset(0);
        make.right.mas_equalTo(_play).offset(-80);
    }];
    
    [_nextPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.and.width.mas_equalTo(80);
        make.top.mas_equalTo(_play).offset(0);
        make.left.mas_equalTo(_play).offset(80);
    }];
    
    [_showlistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.and.width.mas_equalTo(80);
        make.top.mas_equalTo(_play).offset(0);
        make.right.mas_equalTo(_previousPlay).offset(-80);
    }];
    
    _act.center = self.center;
    
}


@end
