//
//  RSShoppingCartTableViewCell.m
//  RedStarMain
//
//  Created by 郭进 on 16/7/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RSShoppingCartTableViewCell.h"
#import "RSShoppingCartDataSourceModel.h"
//#import "RSShoppingCartGoodsInfoModel.h"


@interface RSShoppingCartTableViewCell ()

@property (nonatomic, assign) BOOL isEditting;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation RSShoppingCartTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//选中按钮点击事件
- (IBAction)isOrSelectedForShopBtnOnClick:(id)sender {
    
    _isSelected = !_isSelected;
    
    [self setUpButtonUIState];
    //修改数据源
    _model.isSelected = _isSelected;
    
    for (RSShoppingCartGoodsInfoModel *goodsModel in _model.products) {
        //修改商品Model中的数据，让shop和goods选中联动，这里是选中shop，则goods全选，取消也一样
        goodsModel.isSelected = _model.isSelected;
    }
    
    //代理去执行这个方法，改变goodsCell的编辑状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(popRSShoppingCartGoodsCellEditPage:)]) {
        NSInteger section = _model.section;
        [self.delegate popRSShoppingCartGoodsCellEditPage:section];
    }
    
    //通知VC是否需要改变全选按钮状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSelectAllBtnStateWithSelectState:)]) {
        [self.delegate changeSelectAllBtnStateWithSelectState:_isSelected];
    }
}

//店铺按钮点击事件
- (IBAction)shopBtnOnClick:(id)sender {
    NSLog(@"跳转到店铺！");
}

//领券按钮点击事件
- (IBAction)couponsBtnOnClick:(id)sender {
    NSLog(@"底部弹出领券页面！");
}

//编辑按钮点击事件
- (IBAction)editBtnOnClick:(id)sender {
    _isEditting = !_isEditting;
    [self setUpButtonUIState];
    //修改数据源
    _model.isEditing = _isEditting;
    for (RSShoppingCartGoodsInfoModel *goodsModel in _model.products) {
        //修改商品Model中的数据，让shop和goods编辑状态一致
        goodsModel.isEditing = _model.isEditing;
    }

    //代理去执行这个方法，改变goodsCell的编辑状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(popRSShoppingCartGoodsCellEditPage:)]) {
        NSInteger section = _model.section;
        [self.delegate popRSShoppingCartGoodsCellEditPage:section];
    }
}

//设置数据
- (void)setModel:(RSShoppingCartDataSourceModel *)model
{
    if (model) {
        _model = model;
        _isSelected = model.isSelected;
        _isEditting = model.isEditing;
        //填充UI
        [self setUpButtonUIState];
        
    }
}

//设置选中按钮的状态
- (void)setUpButtonUIState{
    
    if (_isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_checked"] forState:UIControlStateNormal];
    }else {
        [_selectedBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_unchecked"] forState:UIControlStateNormal];
    }
    
    if (_isEditting) {
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else {
         [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}


@end
