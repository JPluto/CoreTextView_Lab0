//
//  UIButton+Utils.h
//  TaduUtils
//
//  Created by Deheng Xu on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utils)

- (void)startAnimationForHidden;
- (void)startAnimationForShown;
- (void)startAnimationForMovingToPoint:(CGPoint) newPosition;
- (void)startAnimationForMovingToDeltax:(CGFloat)dx andDeltay:(CGFloat)dy;

@end
