//
//  MusicListCell.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/31.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "MusicListCell.h"

@interface MusicListCell()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *musicImage;
@end

@implementation MusicListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self onCreate];
    }
    return self;
}

-(void)onCreate{
    UIImageView *musicImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 33, 10, 24, 24)];
    musicImage.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:musicImage];
    _musicImage = musicImage;
    
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 1; i < 7; i++) {
        NSString * imageName = [NSString stringWithFormat:@"%d",i];
        UIImage * image = [UIImage imageNamed:imageName];
        [array addObject:image];
    }
    self.musicImage.animationImages = array;
    self.musicImage.animationDuration = 1.2;
}


-(void)layoutSubviews{
    _musicImage.frame = CGRectMake(self.frame.size.width - 34, 10, 24, 24);
    [_musicImage startAnimating];
}

@end
