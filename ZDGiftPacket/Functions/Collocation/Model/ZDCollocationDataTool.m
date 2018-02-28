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

@end
