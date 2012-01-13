//
//  SimpleTextParams.m
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-10.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextParams.h"

@implementation SimpleTextParams

@synthesize foregroundColor;

- (id)init
{
    self = [super init];
    if (self) {
        foregroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)dealloc
{
    [foregroundColor release];
    [super dealloc];
}
@end
