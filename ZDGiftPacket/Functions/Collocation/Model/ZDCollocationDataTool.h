//
//  ZDCollocationDataTool.h
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/28.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CollocationMaterialAlbumName @"软装搭配素材图" 

@interface ZDCollocationDataTool : NSObject

// return image elements's name
+ (NSArray<NSString *> *)getCollocationData:(NSString *)elementType;


/** 加载相册中的产品 */
+ (void)getCustomMaterialData:(void (^)(NSArray<SPAsset *> *resultArr))callback;

@end
