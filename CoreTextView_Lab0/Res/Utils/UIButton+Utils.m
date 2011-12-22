//
//  UIButton+Utils.m
//  TaduUtils
//
//  Created by Deheng Xu on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startAnimationForHidden
{
    [UIView beginAnimations:nil context:nil];
    [self setAlpha:0.0f];
    [UIView commitAnimations];
}

- (void)startAnimationForShown
{
    [UIView beginAnimations:nil context:nil];
    [self setAlpha:1.0f];
    [UIView commitAnimations];
}

- (void)startAnimationForMovingToPoint:(CGPoint)newPosition
{
    CGRect fm = self.frame;
    [UIView beginAnimations:nil context:nil];
    fm.origin = newPosition;
    self.frame = fm;
    [UIView commitAnimations];
}

- (void)startAnimationForMovingToDeltax:(CGFloat)dx andDeltay:(CGFloat)dy
{
    CGRect fm = self.frame;
    [UIView beginAnimations:nil context:nil];
    fm.origin = CGPointMake(fm.origin.x + dx, fm.origin.y);
    self.frame = fm;
    [UIView commitAnimations];
}

@end
