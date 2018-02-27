//
//  SPPhotoManager.h
//  ZhiDao
//
//  Created by Joey on 2017/8/1.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@class SPAsset;


typedef void (^SPWriteAssetCompletionBlock)(SPAsset *asset, NSError *error);
typedef void (^SPGetAssetCollectionResultBlock)(PHAssetCollection *assetCollection, NSError *error);

/**
 保存Image到本地相册

 @param image 需要保存的Image对象
 @param albumName 相册名（如果没有对应相册，则自动创建）
 @param completionHanlder 完成回调
 */
FOUNDATION_EXTERN void PMSaveImageToAlbum(UIImage *image, NSString *albumName, SPWriteAssetCompletionBlock completionHanlder);

NS_ASSUME_NONNULL_BEGIN

@interface SPPhotoManager : NSObject

+ (instancetype)defaultManager;


#pragma mark - Authorization

/**
 用户权限检测

 @param handler 向用户请求权限结果的反馈回调
 */
- (void)checkupAuthorization:(void(^)(PHAuthorizationStatus status))handler;

#pragma mark - Creating

/**
 保存Image到本地相册
 
 @param image 需要保存的Image对象
 @param albumName 相册名（如果没有对应相册，则自动创建）
 @param completionHanlder 完成回调
 */
- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)albumName
  completionBlock:(SPWriteAssetCompletionBlock)completionBlock;


/**
 获取对应相册（如果无相册，会自动创建）

 @param albumName 相册名
 @return PHAssetCollection
 */
- (void)getAssetCollection:(NSString *)albumName
             resultHandler:(SPGetAssetCollectionResultBlock)handler;

#pragma mark - Fetching


/**
 获取指定图片资源
 
 @param identifier PHAsset.localIdentifier
 */
- (UIImage *)fetchImageWithLocalIdentifier:(NSString *)identifier;
- (UIImage *)fetchThumbnailWithLocalIdentifier:(NSString *)identifier;

/**
 获取相册内所有图片资源

 @param albumName 相册名
 @param assending 根据创建时间creationDate进行排序，YES:升序，NO:降序
 @param enumerationBlock 遍历回调，每次调用返回一个SPAsset资源对象（包含originImage、指定size的thumbnail），遍历完成会返回nil，可以通过判断回调参数是否为nil来判断遍历是否结束
 */
- (void)enumerateAssetsInAlbum:(NSString *)albumName
                 withAscending:(BOOL)assending
                    usingBlock:(void (^)(SPAsset *asset))enumerationBlock;

- (void)deleteAsset:(PHAsset *)assets resultHanlder:(void (^)(NSError *))handler;

@end

NS_ASSUME_NONNULL_END
