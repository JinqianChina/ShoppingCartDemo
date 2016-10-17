//
//  RSShoppingCartGoodsListCell.h
//  RedStarMain
//
//  Created by 郭进 on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSShoppingCartGoodsInfoModel;
@class RSShoppingCartDataSourceModel;

static NSString *_Nullable cellIdentifierForGoodsList = @"RSShoppingCartGoodsListCell";

//block
typedef void(^popGoodsDetailViewBlock)();


//代理
@protocol  RSShoppingCartGoodsListCellDelegate <NSObject>

@optional
//这里刷新section
- (void)reloadSectionOrRowWithSection:(NSInteger)section;
//是否删除section，并刷新tableview
- (void)isOrDeleteCurrentSectionWithSection:(NSInteger)section;

//通知控制器是否改变全选按钮状态
- (void)changeSelectAllBtnStateWithSelectState:(BOOL)isSelected;

@end


@interface RSShoppingCartGoodsListCell : UITableViewCell
//基本信息相关
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCurrentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsOldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSelcetedCount;

//编辑页面相关
@property (weak, nonatomic) IBOutlet UIView *goodsEditingView;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecEditing;
@property (weak, nonatomic) IBOutlet UITextField *goodsSelectCountText;


//model
@property (nonatomic, strong, nullable) RSShoppingCartGoodsInfoModel *model;
@property (nonatomic, strong, nullable) RSShoppingCartDataSourceModel *shopModel;
//代理
@property (nonatomic, weak, nullable) id<RSShoppingCartGoodsListCellDelegate> delegate;
//block
@property (nonatomic, copy, nullable) popGoodsDetailViewBlock popGoodsDetailView;

@end
