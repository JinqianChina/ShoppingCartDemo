//
//  JQPopMasksView.h
//  HLFitment
//
//  Created by 郭进 on 16/5/27.
//  Copyright © 2016年 dickWang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATE_DURATION    0.35f

@protocol JQPopMasksViewDelegate <NSObject>


@end

@interface JQPopMasksView : UIView

@property (nonatomic, strong) UIView *masksView; //遮罩视图
@property (nonatomic, strong) UIView *activityView; //活跃视图
@property (nonatomic, assign) CGFloat JQActivityHeight; //活跃视图高度
@property (nonatomic, copy) NSString *masksViewColorHexString; //遮罩视图颜色
@property (nonatomic, assign) CGFloat masksViewAlpha; //遮罩视图透明度(0 - 1)
@property (nonatomic, weak) id<JQPopMasksViewDelegate> delegate; //代理

//初始化遮罩视图
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JQPopMasksViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;

//弹出遮罩视图
- (void)showPopMasksViewInView:(UIView *)view;
//取消弹出视图
- (void)tappedCancel;

@end
