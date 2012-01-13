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
@synthesize viewsBufferCount;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        views = [NSMutableArray new];
        viewsBufferCount = 3;
        [self updateViewsBuffer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        viewsBufferCount = 3;
        NSMutableArray * tmp = [NSMutableArray new];
        NSAutoreleasePool * pool = [NSAutoreleasePool new];
        [self updateViewsBuffer];
        [pool drain];
        [tmp release];
    }
    
    return self;
}

- (void)updateViewsBuffer
{
    @synchronized(views) {
        if (viewsBufferCount == [views count]) {
            //Don't need update views buffer!
            return;
        }
        NSArray * tmp = self.views;
        NSMutableArray * newViews = [NSMutableArray array];
        if (viewsBufferCount < [views count]) {
            for (int i = 0; i < viewsBufferCount; i++) {
                [newViews addObject:[tmp objectAtIndex:i]];
            }
        }else {
            int  i = 0;
            //
            for (i = 0; i < [tmp count]; i++) {
                [newViews addObject:[tmp objectAtIndex:i]];
            }
            //fill the clear view to extended space
            for ( ; i < viewsBufferCount; i++) {
                [newViews addObject:[[UIView new] autorelease]];
            }
        }
        self.views = newViews;
    }
}

- (void)loadViewsBufferAtPage:(NSUInteger)page ofBook:(NSString *)bookContent
{
    
}

//switch views from right to left
- (void)switchViewBufferToLeft:(UIView *)view
{
    if (views.count <= 1) {
        return;
    }
    int i = 0;
    UIView * tmp = [[views objectAtIndex:i] retain];
    i++;
    for (; i < views.count; i++) {
        [(NSMutableArray*)views replaceObjectAtIndex:i - 1 withObject:[views objectAtIndex:i]];
    }
    [(NSMutableArray*)views replaceObjectAtIndex:i withObject:tmp];
    [tmp release];
}

//switch views from left to right
- (void)switchViewBufferToRight:(UIView *)view
{
    if (views.count <= 1) {
        return;
    }
    int i = views.count - 1;
    UIView * tmp = [[views objectAtIndex:i] retain];
    i--;
    for (; i >= 0; i--) {
        [(NSMutableArray*)views replaceObjectAtIndex:i + 1 withObject:[views objectAtIndex:i]];
    }
    [(NSMutableArray*)views replaceObjectAtIndex:i withObject:tmp];
    [tmp release];
}


@end
