//
//  RSShoppingCartGoodsInfoModel.h
//  RedStarMain
//
//  Created by 郭进 on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSShoppingCartGoodsInfoModel : NSObject

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, copy) NSString *picName;
@property (nonatomic, copy) NSString *nowPrice;
@end
