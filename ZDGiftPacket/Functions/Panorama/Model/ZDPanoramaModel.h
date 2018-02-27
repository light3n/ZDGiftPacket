//
//  ZDPanoramaModel.h
//  PanoramaDemo
//
//  Created by Joey on 2018/1/25.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDPanoramaModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *topImageStr;
@property (nonatomic, strong) NSString *bottomImageStr;
@property (nonatomic, strong) NSString *leftImageStr;
@property (nonatomic, strong) NSString *rightImageStr;
@property (nonatomic, strong) NSString *forwardImageStr;
@property (nonatomic, strong) NSString *backwardImageStr;

@end
