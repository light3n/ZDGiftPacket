//
//  ZDPanoramaViewController.m
//  PanoramaDemo
//
//  Created by Joey on 2018/1/26.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "ZDPanoramaViewController.h"
#import "ZDPanoramaDetailViewController.h"
#import "ZDPanoramaDisplayViewController.h"
#import "JAPanoView.h"
#import "ZDPanoramaDataTool.h"
#import "ZDPanoramaViewCell.h"
#import "SPPhotoManager.h"

@interface ZDPanoramaViewController () <ZDPanoramaViewCellDelegate>

@end

@implementation ZDPanoramaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZDPanoramaViewCell" bundle:nil] forCellReuseIdentifier:@"ZDPanoramaViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZDPanoramaDataTool totalData].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDPanoramaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZDPanoramaViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.dataDict = [[ZDPanoramaDataTool totalData] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZDPanoramaViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ZDPanoramaDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PanoramaDetail"];
    vc.dataDict = cell.dataDict;
    vc.dataIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ZDPanoramaViewCellDelegate

- (void)panoramaViewCell:(ZDPanoramaViewCell *)cell willPreviewPanoramaWithData:(NSDictionary *)dataDict {
    NSString *topStr = [dataDict objectForKey:@"top"];
    NSString *bottomStr = [dataDict objectForKey:@"bottom"];
    NSString *leftStr = [dataDict objectForKey:@"left"];
    NSString *rightStr = [dataDict objectForKey:@"right"];
    NSString *forwardStr = [dataDict objectForKey:@"forward"];
    NSString *backwardStr = [dataDict objectForKey:@"backward"];
    if (![topStr length]
        || ![bottomStr length]
        || ![leftStr length]
        || ![rightStr length]
        || ![forwardStr length]
        || ![backwardStr length]) {
        NSLog(@"请设置所有方位图片！");
        return;
    }
    SPPhotoManager *mgr = [SPPhotoManager defaultManager];
    ZDPanoramaDisplayViewController *vc = [[ZDPanoramaDisplayViewController alloc] init];
    [vc.panoView setFrontImage:[mgr fetchImageWithLocalIdentifier:forwardStr]
                    rightImage:[mgr fetchImageWithLocalIdentifier:rightStr]
                     backImage:[mgr fetchImageWithLocalIdentifier:backwardStr]
                     leftImage:[mgr fetchImageWithLocalIdentifier:leftStr]
                      topImage:[mgr fetchImageWithLocalIdentifier:topStr]
                   bottomImage:[mgr fetchImageWithLocalIdentifier:bottomStr]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)panoramaViewCell:(ZDPanoramaViewCell *)cell willEditData:(NSDictionary *)dataDict {
    ZDPanoramaDetailViewController *vc = [[UIStoryboard storyboardWithName:@"panorama" bundle:nil] instantiateViewControllerWithIdentifier:@"PanoramaDetail"];
    vc.dataDict = cell.dataDict;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
