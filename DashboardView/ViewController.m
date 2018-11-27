//
//  ViewController.m
//  DashboardView
//
//  Created by Chan on 2018/10/19.
//  Copyright © 2018 Chan. All rights reserved.
//

#import "ViewController.h"
#import "JCDashboardView.h"

@interface ViewController ()

@property (nonatomic, strong) JCDashboardView *dashBoardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.bounds.size.width - 20;
    CGFloat height = width;
    _dashBoardView = [[JCDashboardView alloc] initWithFrame:CGRectMake(10,
                                                                       50,
                                                                       width,
                                                                       height)];
    _dashBoardView.backgroundColor = [UIColor blackColor];
    _dashBoardView.layer.cornerRadius = 0.5 * width;
    _dashBoardView.layer.masksToBounds = YES;
    [self.view addSubview:_dashBoardView];
    [_dashBoardView draw];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _dashBoardView.progress = arc4random() % 100 / 100.0;
}


@end
