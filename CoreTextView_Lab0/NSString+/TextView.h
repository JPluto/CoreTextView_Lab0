//
//  TextView.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-14.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBaseView.h"

#define DEBUG_SHOW_TIME_ONVIEW  1

@class SimpleTextProcessor;
@class SimpleTextParams;

@interface TextView : TextBaseView
{
}

@property (nonatomic, retain) SimpleTextProcessor * txtProcessor;

+ (SimpleTextParams*)uniqTextParams;
- (void)updateTextParams;

- (void)loadPage:(NSUInteger)page;//加载指定页面
- (void)loadCurrentPage;//加载当前页面
- (void)preLoadNextPage;//预加载后面的页面
- (void)preLoadPrevPage;//预加载前面的页面

@end
