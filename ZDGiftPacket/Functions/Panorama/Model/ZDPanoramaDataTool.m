//
//  ZDPanoramaDataTool.m
//  PanoramaDemo
//
//  Created by Joey on 2018/2/1.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "ZDPanoramaDataTool.h"

#define SP_USER_DEFAULT_PANORAMA     @"SP_USER_DEFAULT_PANORAMA"

static NSMutableArray *imageData;


@implementation ZDPanoramaDataTool

+ (void)update {
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:SP_USER_DEFAULT_PANORAMA];
}

/// 查
+ (NSArray *)totalData {
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:SP_USER_DEFAULT_PANORAMA];
    if (!array || !array.count) {
        imageData = [NSMutableArray array];
    } else {
        imageData = [NSMutableArray arrayWithArray:array];
    }
    return imageData;
}

/// 增删
+ (void)addData:(NSDictionary *)data {
    if (!imageData.count) {
        imageData = [NSMutableArray array];
    }
    [imageData addObject:data];
    [self update];
    
}
+ (void)deleteDataAtIndex:(NSInteger)index completion:(void (^)(void))callback {
    if (index < 0 || index >= imageData.count) {
        return;
    }
    [imageData removeObjectAtIndex:index];
    [self update];
    !callback ?: callback();
}

/// 更新指定全景数据
+ (void)updateData:(NSDictionary *)dataDict atIndex:(NSInteger)index {
    if (index > 0 && index < imageData.count) {
        [imageData replaceObjectAtIndex:index withObject:dataDict];
    } else {
        [self addData:dataDict];
    }
    [self update];
}

@end
