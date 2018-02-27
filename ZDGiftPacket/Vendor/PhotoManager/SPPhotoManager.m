//
//  SPPhotoManager.m
//  ZhiDao
//
//  Created by Joey on 2017/8/1.
//  Copyright © 2017年 ZhiDao. All rights reserved.
//

#import "SPPhotoManager.h"
#import "SPAsset.h"

void PMSaveImageToAlbum(UIImage *image, NSString *albumName, SPWriteAssetCompletionBlock completionHanlder) {
    [[SPPhotoManager defaultManager] saveImage:image toAlbum:albumName completionBlock:completionHanlder];
}

@implementation SPPhotoManager {
    PHPhotoLibrary *_photoLibrary;
    PHCachingImageManager *_imageManager;
}

+ (instancetype)defaultManager {
    static SPPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPPhotoManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
        _imageManager = [PHCachingImageManager new];
    }
    return self;
}

- (void)checkupAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        if (handler) {
            handler(PHAuthorizationStatusAuthorized);
        }
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(status);
                });
            }
        }];
    }
}

#pragma mark - Creating

- (void)saveImage:(UIImage *)image
          toAlbum:(NSString *)albumName
  completionBlock:(SPWriteAssetCompletionBlock)completionBlock {
    if (!image) {
        if (completionBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"com.zhidao3d.domain.imageToSavedIsNil"
                                                        code:520
                                                    userInfo:@{NSLocalizedDescriptionKey : @"image must not be nil!"}];
            completionBlock(nil, error);
        }
        return;
    }
    NSData *imageData =  UIImagePNGRepresentation(image);
    UIImage *pngImage = [UIImage imageWithData:imageData];
    
    [self getAssetCollection:albumName resultHandler:^(PHAssetCollection *assetCollection, NSError *error) {
        if (assetCollection) {
            __block NSString *assetLocalId = nil;;
            [_photoLibrary performChanges:^{
                PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:pngImage];
                PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
                assetLocalId = placeholder.localIdentifier;
                PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                if (placeholder) {
                    [collectionRequest addAssets:@[placeholder]];
                }
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"Photo Manager finished adding asset to album [%@]. (%@)", albumName, (success ? @"Success" : error));
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalId] options:nil];
                            if (result.firstObject) {
                                PHAsset *phAsset= result.firstObject;
                                SPAsset *spAsset = [[SPAsset alloc] initWithPHAsset:phAsset];
                                completionBlock(spAsset, nil);
                            } else {
                                completionBlock(nil, error);
                            }
                        } else {
                            completionBlock(nil, error);
                        }
                    });
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)getAssetCollection:(NSString *)albumName
             resultHandler:(SPGetAssetCollectionResultBlock)handler {
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in fetchResult) {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            if (handler) {
                handler(collection, nil);
                return;
            }
        }
    }
    
    __block NSString *createdCollectionID = nil;
    [_photoLibrary performChanges:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        PHObjectPlaceholder *placeholder = request.placeholderForCreatedAssetCollection;
        createdCollectionID = placeholder.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"Photo Manager finished creating album [%@]. (%@)", albumName, (success ? @"Success" : error));
        if (handler) {
            if (error) {
                handler(nil, error);
            } else {
                handler([[PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil] firstObject], nil);
            }
        }
    }];
}


#pragma mark - Fetching

- (void)enumerateAssetsInAlbum:(NSString *)albumName
                 withAscending:(BOOL)assending
                    usingBlock:(void (^)(SPAsset *asset))enumerationBlock {
    [self getAssetCollection:albumName resultHandler:^(PHAssetCollection *assetCollection, NSError *error) {
        if (assetCollection) {
            PHFetchOptions *fetchOptions = [PHFetchOptions new];
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:assending]];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
            NSMutableArray *assetArray = [NSMutableArray array];
            [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAsset *asset = (PHAsset *)obj;
                [assetArray addObject:asset];
            }];
            
            //    PHImageRequestOptions *imageRequestOptions = [PHImageRequestOptions new];
            //    imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            //    [_imageManager startCachingImagesForAssets:[assetArray copy] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:imageRequestOptions];
            
            for (PHAsset *asset in assetArray) {
                SPAsset *spAsset = [[SPAsset alloc] initWithPHAsset:asset];
                if (enumerationBlock) {
                    enumerationBlock(spAsset);
                }
            }
            /**
             *  For 循环遍历完毕，这时再调用一次 enumerationBlock，并传递 nil 作为实参，作为枚举资源结束的标记。
             *  该处理方式也是参照系统 ALAssetGroup 枚举结束的处理。
             */
            if (enumerationBlock) {
                enumerationBlock(nil);
            }
        } else {
            if (enumerationBlock) {
                enumerationBlock(nil);
            }
        }
        

    }];
    
}

- (UIImage *)fetchImageWithLocalIdentifier:(NSString *)identifier {
    if (!identifier || !identifier.length) {
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    PHAsset *phAsset = result.firstObject;
    SPAsset *spAsset = [[SPAsset alloc] initWithPHAsset:phAsset];
    return spAsset.originImage;
}

- (UIImage *)fetchThumbnailWithLocalIdentifier:(NSString *)identifier {
    if (!identifier || !identifier.length) {
        return nil;
    }
    PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    PHAsset *phAsset = result.firstObject;
    SPAsset *spAsset = [[SPAsset alloc] initWithPHAsset:phAsset];
    return [spAsset thumbnailWithSize:CGSizeMake(150, 115)];
}

- (void)deleteAsset:(PHAsset *)assets resultHanlder:(nonnull void (^)(NSError * _Nonnull))handler {
    
    [_photoLibrary performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[assets]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"Photo Manager finished deleting asset [%@]. (%@)", assets, (success ? @"Success" : error));
        if (handler) {
            handler(error);
        }
    }];
}


 







@end

