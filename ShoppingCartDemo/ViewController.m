//
//  ViewController.m
//  ShoppingCartDemo
//
//  Created by 郭进 on 16/7/30.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import "ViewController.h"
#import "RSShoppingCartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 60)];
    [btn setTitle:@"仿淘宝购物车" forState:UIControlStateNormal];
    
    [btn setBackgroundColor:[UIColor redColor]];
    
    [btn addTarget:self action:@selector(pushToShoppingCartVC) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:btn];
}

- (void)pushToShoppingCartVC
{
    RSShoppingCartViewController *VC = [[RSShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
