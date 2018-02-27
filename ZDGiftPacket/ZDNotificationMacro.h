//
//  ZDNotificationMacro.h
//  ZhiDao3D
//
//  Created by Joey on 16/9/19.
//  Copyright © 2016年 ZhiDao. All rights reserved.
//

/**
 *  通知宏文件
 */
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif
// 产品特性界面开始按钮通知
extern NSString * const ZDProductionFeatureStartButtonDidClickedNotification;

// DesignViewController 切换当前选中贴图通知（设置贴图亮度/Alpha值时用）
extern NSString * const ZDDesignViewControllChangedCurrentEditImageViewNotification;

// 购物车产品变动通知
extern NSString * const ZDShoppingCartViewControllerDidEditCartItemsNotification;

// 头像更新通知
extern NSString * const ZDUserAvatarDidChangeNotification;


