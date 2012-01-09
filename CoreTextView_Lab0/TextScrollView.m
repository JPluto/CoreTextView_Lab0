//
//  TextScrollView.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextScrollView.h"

@implementation TextScrollView

@synthesize views;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        NSLog(@"%@", DEBUG_FUNCTION_NAME);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        NSLog(@"%@", DEBUG_FUNCTION_NAME);
        NSMutableArray * tmp = [NSMutableArray new];
        NSAutoreleasePool * pool = [NSAutoreleasePool new];
        for (int i  = 0; i < 2; i++) {
            [tmp addObject:[[UIView new] autorelease]];
        }
        self.views = [NSArray arrayWithArray:tmp];        
        [pool drain];
        [tmp release];
    }
    
    return self;
}


@end
