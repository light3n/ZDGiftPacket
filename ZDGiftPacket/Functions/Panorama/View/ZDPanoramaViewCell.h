//
//  ZDPanoramaViewCell.h
//  PanoramaDemo
//
//  Created by Joey on 2018/1/25.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDPanoramaViewCell;

@protocol ZDPanoramaViewCellDelegate <NSObject>
@required
- (void)panoramaViewCell:(ZDPanoramaViewCell *)cell willPreviewPanoramaWithData:(NSDictionary *)dataDict;
- (void)panoramaViewCell:(ZDPanoramaViewCell *)cell willEditData:(NSDictionary *)dataDict;
@end

@interface ZDPanoramaViewCell : UITableViewCell
@property (nonatomic, weak) id<ZDPanoramaViewCellDelegate> delegate;
@property (nonatomic, copy) NSDictionary *dataDict;
@end
