//
//  DesignComponent.h
//  Ija
//
//  Created by Orville on 15/2/9.
//  Copyright (c) 2015年 Orville. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DesignPath.h"

@interface DesignComponent : NSObject

@property(nonatomic, strong) UIImage* originalImage;
@property(nonatomic, strong) UIImage* baseImage; //经过透视变换后的图片,选取的背景=>perspectiveImage
@property(nonatomic, strong) DesignPath* path;//DesignPath
@property(nonatomic, strong) UIBezierPath* drawPath;

@end
