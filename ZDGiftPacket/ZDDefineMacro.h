//
//  ZDDefineMacro.h
//  ZhiDao3D
//
//  Created by Joey on 16/9/16.
//  Copyright © 2016年 ZhiDao. All rights reserved.
//

#ifndef ZDDefineMacro_h
#define ZDDefineMacro_h


//------------------------- 公共类 -------------------------/

#define FMDB_NAME           @"zhidao3d.sqlite" // 数据库名称


//------------------------ 屏幕输出 ------------------------/
//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define ZDLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define ZDLog(FORMAT, ...) nil
#endif


//------------------------ 引用计数 ------------------------/

#if __has_feature(objc_arc)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#else
#define WS(weakSelf)  __block __typeof(&*self)weakSelf = self;
#endif

#define STRONG(weakSelf)  __strong __typeof(&*self)strongSelf = weakSelf;



//------------------------ FRAME MACRO ------------------------/

#define SCREEN_BOUNDS       [UIScreen mainScreen].bounds
#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height


//------------------------ 颜色类 ------------------------/

// RGB颜色（Alpha=1）
#define RGB(r, g, b)        RGBA(r, g, b, 1)
// RGB颜色
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
// 随机颜色
#define SP_RANDOM_COLOR     [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:1.0]

#define UIColorClear [UIColor clearColor]
#define UIColorBlack [UIColor blackColor]
#define UIColorRed [UIColor redColor]
#define UIColorWhite [UIColor whiteColor]

#define UIFontMake(num) [UIFont systemFontOfSize:num]
#define UIImageMake(name) [UIImage imageNamed:name]



//------------------------ 路径类 ------------------------/

// Document路径
#define DIRECTORY_PATH_DOCUMENT     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// Cache路径
#define DIRECTORY_PATH_CACHES       [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// 聚宝盆路径
#define DIRECTORY_PATH_DOWNLOAD     [DIRECTORY_PATH_DOCUMENT stringByAppendingPathComponent:@"DownloadResoures"] 


//------------------------ 设备信息 ------------------------/

// iOS系统版本
#define SYSTEM_VERSION                              [[[UIDevice currentDevice] systemVersion] floatValue]
// App版本号
#define APP_VERSION                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 检查系统版本  EQUAL=相等 GREATER=大于 LESS=小于
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//------------------------ 屏幕适配 ------------------------/

#define IS_IPHONE4      [UIScreen mainScreen].bounds.size.width == 480
#define IS_IPHONE5      [UIScreen mainScreen].bounds.size.width == 568
#define IS_IPHONE6      [UIScreen mainScreen].bounds.size.width == 667
#define IS_IPHONE6PLUS  [UIScreen mainScreen].bounds.size.width == 736
#define IS_IPHONEX      [UIScreen mainScreen].bounds.size.width == 812
#define KEY_WINDOW      [UIApplication sharedApplication].keyWindow

#define IS_IPAD_MINI    [UIScreen mainScreen].bounds.size.height == 768
#define IS_IPAD         [UIScreen mainScreen].bounds.size.height == 768
#define IS_IPAD_10_5    [UIScreen mainScreen].bounds.size.height == 834
#define IS_IPAD_12_9    [UIScreen mainScreen].bounds.size.height == 1024

#define IS_IPHONE       [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone

#define SCREEN_RATE SCREEN_HEIGHT / 768


//------------------------ 数据操作 ------------------------/

#define STANDARD_USER_DEFAULTS      [NSUserDefaults standardUserDefaults]

// 保存数据到偏好设置
#define SAVE_OBJ_TO_USER_DEFAULT(key,Obj) \
({  if (key != nil  && Obj != nil) { \
[[NSUserDefaults standardUserDefaults] setObject:Obj forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]; } \
})
// 获取偏好设置数据
#define GET_OBJ_FROM_USER_DEFAULT(key)  key!=nil ? [[NSUserDefaults standardUserDefaults] objectForKey:key] : nil

#define NOTIFICATION_CENTER         [NSNotificationCenter defaultCenter]


//------------------------ 字符串安全检查 ------------------------/

#define SafeString(string) !string || !string.length || [string isEqualToString:@"<null>"] || [string isEqual:[NSNull null]] ? @"" : string

//------------------------ SDWebImage 缓存释放 ------------------------/

#define ReleaseSDWebImageCacheMemory [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"]


#endif /* ZDDefineMacro_h */
