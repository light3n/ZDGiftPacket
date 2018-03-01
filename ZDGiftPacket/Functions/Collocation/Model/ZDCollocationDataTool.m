//
//  ZDCollocationDataTool.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/28.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDCollocationDataTool.h"

@implementation ZDCollocationDataTool


+ (NSArray<NSString *> *)getCollocationData:(NSString *)elementType {
    NSMutableArray *nameArray = [NSMutableArray array];
    if ([elementType isEqualToString:@"窗帘"]) {
        for (int i=0; i<90; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"抱枕"]) {
        for (int i=0; i<26; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"床品"]) {
        for (int i=0; i<6; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"单椅"]) {
        for (int i=0; i<26; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"地毯"]) {
        for (int i=0; i<26; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"灯具"]) {
        for (int i=0; i<36; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"柜类"]) {
        for (int i=0; i<17; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"几类"]) {
        for (int i=0; i<30; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"沙发"]) {
        for (int i=0; i<31; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"装饰"]) {
        for (int i=0; i<109; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } else if ([elementType isEqualToString:@"桌子"]) {
        for (int i=0; i<14; i++) {
            [nameArray addObject:[NSString stringWithFormat:@"%@_%d", elementType, i]];
        }
    } 
    return [nameArray copy];
}


+ (void)getCustomMaterialData:(void (^)(NSArray<SPAsset *> *resultArr))callback {
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *albumName = CollocationMaterialAlbumName;
    
    if (albumName.length == 0) {
        !callback ?: callback([NSArray array]);
        [SVProgressHUD showErrorWithStatus:@"该相册无素材，请先手动添加素材！"];
        return;
    };
    NSMutableArray *imageArray = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SPPhotoManager defaultManager] enumerateAssetsInAlbum:albumName withAscending:NO usingBlock:^(SPAsset *asset) {
            if (asset) {
                [imageArray addObject:asset];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    !callback ?: callback(imageArray);
                    [SVProgressHUD dismiss];
                });
            }
        }];
    });
}

@end
