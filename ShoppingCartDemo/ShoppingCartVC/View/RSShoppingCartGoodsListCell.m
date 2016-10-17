//
//  RSShoppingCartGoodsListCell.m
//  RedStarMain
//
//  Created by 郭进 on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RSShoppingCartGoodsListCell.h"
#import "RSShoppingCartGoodsInfoModel.h"
#import "RSShoppingCartDataSourceModel.h"

@interface RSShoppingCartGoodsListCell ()

@property (nonatomic, assign) BOOL isSelected;
@end

@implementation RSShoppingCartGoodsListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//goods选中按钮点击
- (IBAction)selectedBtnOnClick:(id)sender {
    
    //点击改变选中状态
    _isSelected = !_isSelected;
    
    //改变数据源
    _model.isSelected = _isSelected;
    BOOL isSelected = YES;
    //这里遍历每个section中的商品Model中选中的状态，用&&操作来判断shopCell是否被选中
    for (RSShoppingCartGoodsInfoModel *goodsModel in _shopModel.products) {
        isSelected = isSelected && goodsModel.isSelected;
    }
    _shopModel.isSelected = isSelected;

    //刷新section，更新UI
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSectionOrRowWithSection:)]) {
        NSInteger section = _model.section;
        [self.delegate reloadSectionOrRowWithSection:section];
    }
    
    //通知VC是否需要改变全选按钮状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSelectAllBtnStateWithSelectState:)]) {
        [self.delegate changeSelectAllBtnStateWithSelectState:_isSelected];
    }
}


//设置数据
- (void)setModel:(RSShoppingCartGoodsInfoModel *)model
{
    if (model) {
        _model = model;
        _isSelected = model.isSelected;
        
        [self setUpUI];
    }
}

//根据数据Model填充UI
- (void)setUpUI
{
    if (_model.isEditing) {
        self.goodsEditingView.hidden = NO;
    }else {
        self.goodsEditingView.hidden = YES;
    }
    
    if (_isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_checked"] forState:UIControlStateNormal];
    }else {
        [_selectedBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_unchecked"] forState:UIControlStateNormal];
    }
    _goodsImageView.image = [UIImage imageNamed:_model.picName];
    self.goodsCurrentPriceLabel.text = [NSString stringWithFormat:@"%@",_model.nowPrice];
}

//减号
- (IBAction)subtractBntOnClick:(id)sender {
    
    NSLog(@"减号按钮点击");
}

//加号
- (IBAction)addBtnOnClick:(id)sender {
    
    NSLog(@"加号按钮点击");
}

//弹出商品详情
- (IBAction)popGoodsDetailView:(id)sender {
    
    NSLog(@"弹出商品详情");
    if (self.popGoodsDetailView) {
        self.popGoodsDetailView();
    }
}

//删除cell
- (IBAction)deleteBtnOnClick:(id)sender {
    
    NSLog(@"删除按钮点击");
    [_shopModel.products removeObjectAtIndex:_model.row];
    
    
    //这里判断没有商品时，要把shopCell也同时删除
    if (0 == _shopModel.products.count) {
        //刷新section，更新UI
        if (self.delegate && [self.delegate respondsToSelector:@selector(isOrDeleteCurrentSectionWithSection:)]) {
            NSInteger section = _model.section;
            [self.delegate isOrDeleteCurrentSectionWithSection:section];
        }
    }else {
        BOOL isSelected = YES;
        //这里遍历每个section中的商品Model中选中的状态，用&&操作来判断shopCell是否被选中
        for (RSShoppingCartGoodsInfoModel *goodsModel in _shopModel.products) {
            isSelected = isSelected && goodsModel.isSelected;
        }
        _shopModel.isSelected = isSelected;
        
        //刷新section，更新UI
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSectionOrRowWithSection:)]) {
            NSInteger section = _model.section;
            [self.delegate reloadSectionOrRowWithSection:section];
        }
    }
    
    //通知VC是否需要改变全选按钮状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeSelectAllBtnStateWithSelectState:)]) {
        [self.delegate changeSelectAllBtnStateWithSelectState:YES];
    }
}

@end
