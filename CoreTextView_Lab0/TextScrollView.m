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
@synthesize preloadCount;
@synthesize fixedPage;
@synthesize currentView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.preloadCount = 3;
        [self updateViewsBuffer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        self.preloadCount = 3;
        [self updateViewsBuffer];
    }
    
    return self;
}

- (void)dealloc
{
    [currentView release];
    [super dealloc];
}

- (void)setPreloadCount:(NSUInteger)aPreloadCount
{
    if (aPreloadCount >= NSNotFound) {
        preloadCount = 1;
    }else
    if (aPreloadCount < 1) {
        preloadCount = 1;
    }else {
        preloadCount = aPreloadCount;
    }
    
    fixedPage = (preloadCount - 1) / 2;
}

- (void)updateViewsBuffer
{
    @synchronized(views) {
        if (views == nil) {
            views = [NSMutableArray array];
        }
        
        NSArray * tmp = self.views;
        UIView * tmpView = nil;
        
        NSMutableArray * newViews = nil;
        if (preloadCount < [views count]) {
            newViews = [NSMutableArray array];
            for (int i = 0; i < viewsBufferCount; i++) {
                [newViews addObject:[tmp objectAtIndex:i]];
            }
        }else if (preloadCount > [views count]) {
            newViews = [NSMutableArray array];
            int  i = 0;
            for (i = 0; i < [tmp count]; i++) {
                
                [newViews addObject:[tmp objectAtIndex:i]];
            }
            //fill the clear view to extended space
            for ( ; i < viewsBufferCount; i++) {
                [newViews addObject:[[UIView new] autorelease]];
            }
        }
        
        if (newViews != nil) {
            self.views = newViews;
        }
        
        for (int i = 0; i < [views count]; i++) {
            tmpView = [views objectAtIndex:i];
            tmpView.frame = self.bounds;
            tmpView = nil;
        }
        
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
