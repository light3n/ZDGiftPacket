//
//  SPAsset.m
//  ZhiDao
//
//  Created by Joey on 2017/8/1.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import "SPAsset.h"
#import <Photos/Photos.h>

@implementation SPAsset

- (instancetype)initWithPHAsset:(PHAsset *)asset {
    if (self = [super init]) {
        _phAsset = asset;
    }
    return self;
}

- (UIImage *)originImage {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    [manager requestImageForAsset:_phAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    return resultImage;
}

- (UIImage *)thumbnailWithSize:(CGSize)size {
    __block UIImage *resultImage = nil;
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    PHCachingImageManager *manager = [[PHCachingImageManager alloc] init];
    CGFloat scale = [UIScreen mainScreen].scale;
    [manager requestImageForAsset:_phAsset targetSize:CGSizeMake(size.width * scale, size.height *scale) contentMode:PHImageContentModeAspectFill options:phImageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImage = result;
    }];
    return resultImage;
}


@end
