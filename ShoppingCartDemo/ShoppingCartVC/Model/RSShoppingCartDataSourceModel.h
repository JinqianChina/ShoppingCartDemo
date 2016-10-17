//
//  RSShoppingCartDataSourceModel.h
//  RedStarMain
//
//  Created by 郭进 on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSShoppingCartGoodsInfoModel.h"

//控制购物车操作的数据源Model
@interface RSShoppingCartDataSourceModel : NSObject

//对于整组的操作
@property (nonatomic, assign) BOOL isEditing;  //是否处于编辑状态
@property (nonatomic, assign) BOOL isSelected; //是否是选中状态
@property (nonatomic, assign) NSInteger section; //具体是哪一组cell


//对于一组内商品cell的操作
@property (nonatomic, strong) NSMutableArray *products;

@end
