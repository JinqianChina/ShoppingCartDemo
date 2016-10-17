//
//  RSShoppingCartTableViewCell.h
//  RedStarMain
//
//  Created by 郭进 on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSShoppingCartDataSourceModel;

static NSString *_Nullable cellIdentifierForShopList = @"RSShoppingCartTableViewCell";


@protocol  RSShoppingCartShopListCellDelegate<NSObject>

@optional
//
- (void)popRSShoppingCartGoodsCellEditPage:(NSInteger)section;

//通知控制器是否改变全选按钮状态
- (void)changeSelectAllBtnStateWithSelectState:(BOOL)isSelected;

@end

@interface RSShoppingCartTableViewCell : UITableViewCell

//代理
@property (nonatomic, weak, nullable) id<RSShoppingCartShopListCellDelegate> delegate;

@property (nonatomic, strong, nullable) RSShoppingCartDataSourceModel *model;

//以下按钮需要改变状态
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end
