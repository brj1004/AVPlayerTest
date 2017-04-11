//
//  AssistiveTouchBar.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/30.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "AssistiveTouchBar.h"
//拖载Button的持续时长
#define KAnimationDuration 0.3f
//按钮在屏幕隐藏的部分(0 -- 1)
#define KScreenPoint 1

#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@interface AssistiveTouchBar()
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation AssistiveTouchBar{
    CGPoint beginPoint;           //开始的坐标
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        NSMutableArray *array = @[].mutableCopy;
        for (int i = 1; i < 7; i++) {
            NSString * imageName = [NSString stringWithFormat:@"%d",i];
            UIImage * image = [UIImage imageNamed:imageName];
            [array addObject:image];
        }
        self.animationImages = array;
        self.animationDuration = 1.2;
    }
    return self;
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (hidden) {
        [self stopAnimating];
    }else{
        [self startAnimating];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_userTouchEnabled) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
    self.alpha = 1;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_userTouchEnabled) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    self.alpha = 1;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint EndPoint = [touch locationInView:self];
    float offsetX = EndPoint.x - beginPoint.x;
    float offsetY = EndPoint.y - beginPoint.y;
    
    if (self.center.x + offsetX >= KScreenWidth*KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(KScreenWidth-self.bounds.size.width*KScreenPoint/2,self.center.y + offsetY);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.bounds.size.width*KScreenPoint/2,self.center.y + offsetY);
        [UIView commitAnimations];
    }
    if (self.center.y + offsetY >= KScreenHeight-self.bounds.size.height*KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.center.x,KScreenHeight-self.bounds.size.height*KScreenPoint/2);
        
        [UIView commitAnimations];
    }else if(self.center.y + offsetY < self.bounds.size.height*KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.center.x,self.bounds.size.height*KScreenPoint/2);
        
        [UIView commitAnimations];
    }else{
        
    }
    [self performSelector:@selector(setTouchAlpha) withObject:nil afterDelay:3];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint EndPoint = [touch locationInView:self];
    float offsetX = EndPoint.x - beginPoint.x;
    float offsetY = EndPoint.y - beginPoint.y;
    
    if (self.center.x + offsetX >= KScreenWidth * KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(KScreenWidth-self.bounds.size.width*KScreenPoint/2,self.center.y + offsetY);
        
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.bounds.size.width*KScreenPoint/2,self.center.y + offsetY);
        
        [UIView commitAnimations];
    }
    if (self.center.y + offsetY >= KScreenHeight-self.bounds.size.height*KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.center.x,KScreenHeight-self.bounds.size.height*KScreenPoint/2);
        
        [UIView commitAnimations];
    }else if(self.center.y + offsetY < self.bounds.size.height*KScreenPoint/2){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:KAnimationDuration];
        self.center = CGPointMake(self.center.x,self.bounds.size.height*KScreenPoint/2);
        
        [UIView commitAnimations];
    }else{
        
    }
}

-(void)setTouchAlpha{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.5;
    }];
}

-(void)tapGestureRecognizer{
    !self.clickTouch ? :self.clickTouch();
}


@end
