//
//  TextBase.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-27.
//  Copyright (c) 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextBaseView.h"

@implementation TextBaseView

@synthesize fontSize;
@synthesize lineSpace;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
