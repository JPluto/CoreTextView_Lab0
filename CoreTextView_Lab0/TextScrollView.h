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
}

@property (nonatomic, retain) NSArray * views;
@property (nonatomic) NSUInteger viewsBufferCount;

- (void)updateViewsBuffer;
- (void)loadViewsBufferAtPage:(NSUInteger) page ofBook:(NSString*)bookContent;
- (void)switchViewBufferToLeft:(UIView*) view;
- (void)switchViewBufferToRight:(UIView*) view;

@end
