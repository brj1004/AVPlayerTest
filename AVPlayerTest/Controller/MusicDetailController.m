//
//  MusicDetailController.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/13.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "MusicDetailController.h"
#import "PlayerManagerTool.h"
#import "AppDelegate.h"
#import "MusicListCell.h"

@interface MusicDetailController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) PlayerManagerTool *managerTool;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MusicDetailController

- (void)loadView{
    self.playView = [FMPlayView new];
    [self.playView.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.view = self.playView;
    self.managerTool = [PlayerManagerTool sharedInstance];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.playView.bounds];
        _backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
        tap.delegate = self;
        [_backView addGestureRecognizer:tap];
        
        [self.playView addSubview:_backView];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _backView.frame.size.height, _backView.frame.size.width, _backView.frame.size.height * 0.6) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_backView addSubview:_tableView];
        
        UILabel *listLabel = [UILabel new];
        listLabel.text = @"音频列表";
        listLabel.frame = CGRectMake(0, 0, _tableView.frame.size.width, 50);
        listLabel.textAlignment = NSTextAlignmentCenter;
        
        _tableView.tableHeaderView = listLabel;
        
        _backView.hidden = YES;
    }else{
        _backView.hidden = NO;
    }
    return _backView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(mediaProgress)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _link.paused = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self backView];
    });
    
    __weak typeof(self) weakSelf = self;
    self.playView.clickPlay = ^(BOOL selected){
        weakSelf.link.paused = NO;
        [weakSelf.managerTool playMusic];
    };
    self.playView.closeDetail = ^(){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.playView.previousBlock = ^(){
        [weakSelf.managerTool previousMusic];
    };
    self.playView.nextBlock = ^(){
        [weakSelf.managerTool nextMusic];
    };
    self.playView.showList = ^(){
        [weakSelf showListViewForTableView];
    };
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeChannel:) name:@"changeChannel" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellID = @"cellID";
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MusicListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"--- %ld",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
}

- (void)showListViewForTableView{
    self.backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = rect.origin.y - self.backView.frame.size.height * 0.6;
        self.tableView.frame = rect;
        [self.tableView becomeFirstResponder];
    }];
}

- (void)removeBackView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = rect.origin.y + self.backView.frame.size.height * 0.6;
        self.tableView.frame = rect;
    }completion:^(BOOL finished) {
        self.backView.hidden = YES;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else {
        return YES;
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.touchBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.touchBar.hidden = NO;
}

- (void)changeChannel:(NSNotification *)sender{
    NSNumber *showAct = sender.object;
    if (showAct.boolValue) {
        [self.playView.act stopAnimating];
    }else{
        [self.playView.act startAnimating];
    }
}

- (void)sliderValueChanged:(UISlider *)sender{
    [_managerTool.player pause];
    self.link.paused = YES;
    self.playView.play.selected = self.managerTool.isPlay = NO;
    
    NSTimeInterval slideTime = CMTimeGetSeconds(_managerTool.player.currentItem.duration) * sender.value;
    if (slideTime == CMTimeGetSeconds(_managerTool.player.currentItem.duration)) slideTime -= 0.5;
    
    self.playView.playTime.text = [self setTimeLabelText:YES duration:slideTime];
    //toleranceBefore time往前多少精准度  toleranceAfter  time往后多少精准度
    [_managerTool.player seekToTime:CMTimeMakeWithSeconds(slideTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)mediaProgress{
    self.playView.slider.value = CMTimeGetSeconds(_managerTool.player.currentItem.currentTime) / CMTimeGetSeconds(_managerTool.player.currentItem.duration);
    self.playView.playTime.text = [self setTimeLabelText:YES duration:CMTimeGetSeconds(_managerTool.player.currentItem.currentTime)];
    self.playView.playCurrentTime.text = [self setTimeLabelText:NO duration:CMTimeGetSeconds(_managerTool.player.currentItem.duration)];
}

#pragma mark - 获取时长与播放进度
- (NSString *)setTimeLabelText:(BOOL)start duration:(int)duration{
    NSString *time;
    int hour = duration / 3600;
    int minute = (duration - hour * 3600) / 60;
    int second = (int)duration % 60;
    if (hour > 0){
        time = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hour, minute, second];
    }else{
        time = [NSString stringWithFormat:@"%.2d:%.2d",minute,second];
    }
    return time;
}

-(void)dealloc{
    [self.managerTool releasePlayer];
    self.managerTool = nil;
    [self.link invalidate];
    self.link = nil;
}


@end
