//
//  ZDCollocationDataTool.h
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/28.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCollocationDataTool : NSObject

// return image elements's name
+ (NSArray<NSString *> *)getCollocationData:(NSString *)elementType;

@end
