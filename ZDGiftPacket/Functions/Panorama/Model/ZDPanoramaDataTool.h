//
//  ZDPanoramaDataTool.h
//  PanoramaDemo
//
//  Created by Joey on 2018/2/1.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDPanoramaDataTool : NSObject

/// 查
+ (NSArray *)totalData;

/// 增删
+ (void)addData:(NSDictionary *)data;
+ (void)deleteDataAtIndex:(NSInteger)index completion:(void (^)(void))callback;

/// 更新指定全景数据
+ (void)updateData:(NSDictionary *)dataDict atIndex:(NSInteger)index;


@end
