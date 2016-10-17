//
//  JQPopMasksView.m
//  HLFitment
//
//  Created by 郭进 on 16/5/27.
//  Copyright © 2016年 dickWang. All rights reserved.
//

#import "JQPopMasksView.h"

@interface JQPopMasksView ()

@end

@implementation JQPopMasksView

#pragma mark --
#pragma mark -- Public Actions

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JQPopMasksViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.userInteractionEnabled = YES;
        
        //活跃视图
        self.activityView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.activityView.backgroundColor = [UIColor greenColor];
        //遮罩视图
        self.masksView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - frame.size.height)];
        self.masksView.backgroundColor = [UIColor blackColor];
        self.masksView.alpha = 0.0;
        self.masksViewAlpha = - 1;
        
        [self addSubview:self.masksView];
        [self addSubview:self.activityView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self.masksView addGestureRecognizer:tapGesture];
        
        if (delegate) {
            self.delegate = delegate;
        }
    }
    return self;
}

- (void)showPopMasksViewInView:(UIView *)view
{
    self.masksViewColorHexString = @"000000";//默认值
    self.masksView.alpha = 0.4;
    [view addSubview:self];
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.activityView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.JQActivityHeight, [UIScreen mainScreen].bounds.size.width, self.JQActivityHeight)];
        [self setMasksViewWithColorHexString:self.masksViewColorHexString andAlpha:1.0];
        if (self.masksViewAlpha >= 0.0 && self.masksViewAlpha <= 1.0) {
            self.masksView.alpha = self.masksViewAlpha;
        }else {
            //默认遮罩层的透明度0.5
            self.masksView.alpha = 0.5;
        }
    } completion:^(BOOL finished) {
        
    }];
}

//设置遮罩层的颜色和透明度
- (void)setMasksViewWithColorHexString:(NSString *)hexStr andAlpha:(CGFloat)alpha
{
    if (self.masksView) {
        if (hexStr == nil && alpha == -1) {
            self.masksView.backgroundColor = [self colorWithHexString:@"#000000" alpha:alpha];
        }else if (hexStr != nil && alpha == -1) {
            self.masksView.backgroundColor = [self colorWithHexString:hexStr alpha:alpha];
        }else if (hexStr != nil && alpha != -1) {
            self.masksView.backgroundColor = [self colorWithHexString:hexStr alpha:alpha];
        }else {
            self.masksView.backgroundColor = [self colorWithHexString:@"#000000" alpha:alpha];
        }
    }
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexString];
    unsigned int hex = 0;
    [scanner scanHexInt:&hex];
    return [self colorWithHex:hex alpha:alpha];//[UIColor colorWithHex:hex alpha:alpha];
}

- (UIColor *)colorWithHex:(int)hex alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

//取消
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.activityView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.masksView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            if ([self respondsToSelector:@selector(removeFromSuperview)]) {
                [self removeFromSuperview];
            }
            
        }
    }];
}

@end
