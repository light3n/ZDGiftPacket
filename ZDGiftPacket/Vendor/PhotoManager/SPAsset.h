//
//  SPAsset.h
//  ZhiDao
//
//  Created by Joey on 2017/8/1.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>

@interface SPAsset : NSObject

@property (nonatomic, strong) PHAsset *phAsset;

- (instancetype)initWithPHAsset:(PHAsset *)asset;

- (UIImage *)originImage;

- (UIImage *)thumbnailWithSize:(CGSize)size;

@end
