//
//  TextScrollView.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextScrollView : UIScrollView
{
    NSUInteger viewsBufferCount;
    //预加载数量控制
    NSUInteger preloadCount;
    NSUInteger fixedPage;
    NSUInteger currentPage;
    UIView * currentView;
}

@property (nonatomic, retain) NSArray * views;
@property (nonatomic) NSUInteger viewsBufferCount;
@property (nonatomic) NSUInteger preloadCount;
@property (nonatomic) NSUInteger fixedPage;
@property (nonatomic, retain) UIView * currentView;

//刷新视图缓冲区
- (void)updateViewsBuffer;
//加载视图缓冲区
- (void)loadViewsBufferAtPage:(NSUInteger) page ofBook:(NSString*)bookContent;
//向左切换缓冲区
- (void)switchViewBufferToLeft:(UIView*) view;
//向右切换缓冲区
- (void)switchViewBufferToRight:(UIView*) view;

@end
