//
//  MovableButton.h
//  InJa
//
//  Created by Orville on 14-2-13.
//  Copyright (c) 2014年 Orville. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovableButton : UIButton
{
    CGFloat xDistance;
    CGFloat yDistance;
    BOOL isDrag;
}

@end
