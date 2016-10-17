//
//  ShoppingCartViewController.m
//  RedStarMain
//
//  Created by LT on 16/7/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RSShoppingCartViewController.h"
//Cell
#import "RSShoppingCartTableViewCell.h"
#import "RSShoppingCartGoodsListCell.h"

//弹出view
#import "JQPopMasksView.h"

//数据源
#import "RSShoppingCartDataSourceModel.h"
#import "RSShoppingCartGoodsInfoModel.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface RSShoppingCartViewController ()<UITableViewDataSource,UITableViewDelegate,RSShoppingCartShopListCellDelegate,RSShoppingCartGoodsListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

//结算相关
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (nonatomic, copy) NSString *totalPriceStr;
//全选按钮状态，默认每次进来是不选中
@property (nonatomic, assign) BOOL isSelected;
//合计
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


//底部弹出视图
@property (nonatomic, strong) JQPopMasksView *popViewFromBottom;

//selectGoodsDetail相关
@property (strong, nonatomic) IBOutlet UIView *popGoodsDetailView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsStockCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecLabel;


@end

@implementation RSShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isSelected = NO;
    self.totalPriceStr = @"￥0.00";
    [self setUpSelectAllBtnState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaseView{
    self.title = @"购物车";
}

- (void)initTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //注册cell
    UINib *nib = [UINib nibWithNibName:cellIdentifierForShopList bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifierForShopList];
    nib = [UINib nibWithNibName:cellIdentifierForGoodsList bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifierForGoodsList];
}

//数据源（模拟）
- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            RSShoppingCartDataSourceModel *model = [[RSShoppingCartDataSourceModel alloc] init];
            model.isEditing = NO;
            model.isSelected = NO;
            if (i == 0) {
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i < 2; i++) {
                    RSShoppingCartGoodsInfoModel *goodsModel = [[RSShoppingCartGoodsInfoModel alloc] init];
                    goodsModel.picName = [NSString stringWithFormat:@"%d.jpg",i];
                    goodsModel.nowPrice = @"1000.00";
                    [arr addObject:goodsModel];
                }
                model.products = arr;
            }else {
                RSShoppingCartGoodsInfoModel *goodsModel = [[RSShoppingCartGoodsInfoModel alloc] init];
                goodsModel.picName = [NSString stringWithFormat:@"%d.jpg",i];
                goodsModel.nowPrice = @"2000.00";
                model.products = [NSMutableArray arrayWithArray:@[goodsModel]];
            }
            [mutableArr addObject:model];
        }
        _dataArr = mutableArr;
    }
    return _dataArr;
}

//结算按钮暂时先用来push到pushToShoppingCartVC
- (IBAction)pushToShoppingCartVC:(id)sender {
    RSShoppingCartViewController *VC = [[RSShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

//全选按钮点击
- (IBAction)selectAllBtnOnClick:(id)sender {
    _isSelected = !_isSelected;
    //全选按钮点击时改变选中状态的数据源
    [self modifyDataSourceByAllSelectState];
    //计算选中商品的价格总和
    [self calculateTotalPriceForSelected];
    //设置全选按钮状态和价格总和
    [self setUpSelectAllBtnState];
    //刷新tableview
    [self.tableView reloadData];
}
//全选按钮点击时改变选中状态的数据源
- (void)modifyDataSourceByAllSelectState
{
    for (RSShoppingCartDataSourceModel *model in self.dataArr) {
        model.isSelected = _isSelected;
        for (RSShoppingCartGoodsInfoModel *goods in model.products) {
            goods.isSelected = _isSelected;
        }
    }
}
//计算选中商品的价格总和
- (void)calculateTotalPriceForSelected
{
    //遍历数据源，计算选中商品的价格总和
    CGFloat totalPrice = 0.00f;
    for (RSShoppingCartDataSourceModel * ShopModel in self.dataArr) {
        for (RSShoppingCartGoodsInfoModel * goodsModel in ShopModel.products) {
            if (goodsModel.isSelected == YES) {
                NSString *nowPrice = [NSString stringWithFormat:@"%@",goodsModel.nowPrice];
                CGFloat nowPriceFloat = [nowPrice floatValue];
                
                totalPrice = totalPrice + nowPriceFloat;
            }
        }
    }
    
    self.totalPriceStr = [NSString stringWithFormat:@"￥%.2f",totalPrice];
}

//设置全选按钮状态和价格总和
- (void)setUpSelectAllBtnState
{
    if (_isSelected) {
        [_selectAllBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_checked"] forState:UIControlStateNormal];
    }else {
        [_selectAllBtn setImage:[UIImage imageNamed:@"shoppingcartpage_icon_unchecked"] forState:UIControlStateNormal];
    }
    self.totalPriceLabel.attributedText = [self attributedStringWithFirstCharacterSize:12 AndOtherCharacterSize:15 AndHaveUnderlineOrNot:NO AndColor:[self hxStringToColor:@"439df7"] WithString:self.totalPriceStr];
}

#pragma mark --
#pragma mark --UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr.count == 0) return 0;
    RSShoppingCartDataSourceModel *model = _dataArr[section];
    //在这里赋值section
    model.section = section;
    return model.products.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        RSShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForShopList forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //代理
        cell.delegate = self;
        //数据
        RSShoppingCartDataSourceModel *model = self.dataArr[indexPath.section];
        cell.model = model;
        return cell;
    }else {
        
        RSShoppingCartGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierForGoodsList forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        //传入block块
        cell.popGoodsDetailView = ^(){
            //这里需要加到window的rootViewController的view上，因为需要遮住tabbar
            UIView *view = [UIApplication sharedApplication].delegate.window.rootViewController.view;
            [self.popViewFromBottom showPopMasksViewInView:view];
        };
        
        //数据
        RSShoppingCartDataSourceModel *model = self.dataArr[indexPath.section];
        RSShoppingCartGoodsInfoModel *goodsModel = model.products[indexPath.row - 1];
        //记录行，用来删除标记
        goodsModel.row = indexPath.row - 1;
        goodsModel.section = model.section;
        
        cell.model = goodsModel;
        cell.shopModel = model;
        return cell;
    }
}

#pragma mark --
#pragma mark --UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 46;
    }else {
        return 120;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSShoppingCartDataSourceModel *model = self.dataArr[indexPath.section];
    if (model.isEditing) {
        NSLog(@"编辑状态下无跳转");
    }else {
        NSLog(@"非编辑状态下，跳转到商品详情");
    }
}


#pragma mark --
#pragma mark -- RSShoppingCartShopListCellDelegate

//点击shopCell上编辑按钮时，刷新section，弹出编辑页面
- (void)popRSShoppingCartGoodsCellEditPage:(NSInteger)section
{
    //一个section刷新
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --
#pragma mark -- RSShoppingCartGoodsListCellDelegate

//点击goodsCell上选中按钮和删除按钮时刷新section
- (void)reloadSectionOrRowWithSection:(NSInteger)section
{
    //一个section刷新
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

//通知控制器是否需要删除当前section，删除section后tableview要reloadData
- (void)isOrDeleteCurrentSectionWithSection:(NSInteger)section {
    [self.dataArr removeObjectAtIndex:section];
    [self.tableView reloadData];
}

#pragma mark -- RSShoppingCartGoodsListCellDelegate && RSShoppingCartShopListCellDelegate
//通知VC是否需要改变全选按钮状态
- (void)changeSelectAllBtnStateWithSelectState:(BOOL)isSelected
{
    
    if (isSelected) {
        //当传来的选中状态为YES时，才去遍历数据源，判断是否需要
        if (0 == self.dataArr.count) {
            isSelected = NO;
        }else {
            for (RSShoppingCartDataSourceModel * model in self.dataArr) {
                isSelected = isSelected && model.isSelected;
            }
        }
        
        _isSelected = isSelected;
        
    }else {
        //为NO时，不需要遍历数据源
        _isSelected = isSelected;
    }
    //计算价格总和
    [self calculateTotalPriceForSelected];
    //设置选中按钮状态UI
    [self setUpSelectAllBtnState];
}


#pragma mark --
#pragma mark -- 选中商品详情弹出视图相关

//懒加载
- (JQPopMasksView *)popViewFromBottom
{
    if (!_popViewFromBottom) {
        //弹出的遮罩视图底部的活跃视图
        UIView *bottomPopView = self.popGoodsDetailView;
        CGFloat heightOfPopView = 465;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, heightOfPopView);
        bottomPopView.frame = frame;
        
        CGRect popFrame = CGRectMake(0, 0, ScreenWidth, 0);
        JQPopMasksView *popView = [[JQPopMasksView alloc] initWithFrame:popFrame delegate:nil cancelButtonTitle:@"取消"];
        popView.masksViewColorHexString = @"000000";
        popView.masksViewAlpha = 0.4;
        popView.JQActivityHeight = heightOfPopView;
        [popView.activityView addSubview:bottomPopView];
        [popView showPopMasksViewInView:self.view];
        _popViewFromBottom = popView;
        //设置一些UI细节
        [self initPopGoodsDetailViewUI];
    }
    return  _popViewFromBottom;
}

//设置选中goods信息的UI细节
- (void)initPopGoodsDetailViewUI
{
    //商品图片
    self.goodsImageView.image = [UIImage imageNamed:@"0.jpg"];
    self.goodsImageView.backgroundColor = [UIColor yellowColor];
    self.goodsImageView.layer.cornerRadius = 4;
    self.goodsImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.goodsImageView.layer.borderWidth = 5;
    [self.goodsImageView.layer setMasksToBounds:YES];
}

//设置选中商品数据
- (void)setUpGoodsDetailView
{
    
}

- (IBAction)popGoodsDetailViewCancle:(id)sender {
    //点击取消弹出视图
    [_popViewFromBottom tappedCancel];
}

- (IBAction)popGoodsDetailViewMakeSureBtnOnClick:(id)sender {
    //点击确认按钮取消弹出视图
    [_popViewFromBottom tappedCancel];
}



//16进制颜色(html颜色值)字符串转为UIColor
- (UIColor *) hxStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSMutableAttributedString *)attributedStringWithFirstCharacterSize:(CGFloat)firstSize AndOtherCharacterSize:(CGFloat)otherSize AndHaveUnderlineOrNot:(BOOL) HaveUnderlineOrNot AndColor:(UIColor *)color WithString:(NSString *)str
{
    NSInteger length = str.length;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:firstSize]
     
                          range:NSMakeRange(0, 1)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:otherSize]
     
                          range:NSMakeRange(1, length - 1)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:color
     
                          range:NSMakeRange(0, length)];
    
    if (HaveUnderlineOrNot) {
        
        [AttributedStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
        [AttributedStr addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    }
    
    return AttributedStr;
}




@end

