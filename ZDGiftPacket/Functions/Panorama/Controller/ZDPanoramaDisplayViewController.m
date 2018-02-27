//
//  ZDPanoramaDisplayViewController.m
//  PanoramaDemo
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "ZDPanoramaDisplayViewController.h"


@interface ZDPanoramaDisplayViewController ()

@end

@implementation ZDPanoramaDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    backButton.frame = CGRectMake(15, 10, 80, 40);
    [backButton setTitle:@"<返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (JAPanoView *)panoView {
    if (!_panoView) {
        _panoView = [[JAPanoView alloc] initWithFrame:self.view.frame];
        [self.view insertSubview:_panoView atIndex:0];
    }
    return _panoView;
}

- (void)backButtonEventHandler {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
