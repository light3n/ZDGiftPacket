//
//  ZDCollocationDataTool.h
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/28.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CollocationMaterialStyle @"软装搭配素材图"
#define CollocationMaterialAlbumName @"软装搭配素材图"
#define CollocationMaterialAlbumName @"软装搭配素材图"
#define CollocationMaterialAlbumName @"软装搭配素材图"
#define CollocationMaterialAlbumName @"软装搭配素材图"
#define CollocationMaterialAlbumName @"软装搭配素材图" 

@interface ZDCollocationDataTool : NSObject

#pragma mark - Style Menu

+ (NSArray<NSString *> *)getStyleMenu:(NSString *)style;

#pragma mark - Material

// return image elements's name
+ (NSArray<NSString *> *)getCollocationData:(NSString *)elementType;

// 加载用户自己抠图添加的素材
+ (void)getCustomMaterialData:(void (^)(NSArray<SPAsset *> *resultArr))callback;

@end
