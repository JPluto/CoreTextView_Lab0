//
//  CoreTextView.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBaseView.h"

#define DRAW_TEXT_LINE_BY_LINE	1

@class CoreTextHelper;
@class CoreTextProcessor;

@interface CoreTextView : TextBaseView {
@public
    //manul control data
    CFRange visibleRange;
    CTFrameRef visibleFrameRef;
    CGRect visibleBounds;
    
    //CoreText framework drawing
    CFMutableAttributedStringRef cfAttrStringRef;
    CFArrayRef ctLinesArrayRef;
    CFIndex startGlyphIndex;
    CFIndex totalGlyphCount;
    CTFontRef ctFontRef;
    
    //Text selection
    CGRect selectedRect;
    CFIndex selectedStartIndex;
    CFIndex selectedEndIndex;
    CFIndex selectedStartLine;
    CFIndex selectedEndLine;
    
    //CoreGraphic & CoreQuartz
    CGContextRef m_Context;
	
}

@property (nonatomic, retain) CoreTextHelper * coreTextHelper;
@property (nonatomic, retain) CoreTextProcessor * coreTextProcessor;

//初始化 coretext 参数
- (void)initCoreTextParams;
//更新并应用 coretext 参数
- (void)updateCoreTextParams;
//加载可视区域文本行数
- (void)loadVisibleTextForCFRange:(CFRange)rang;
//重新加载文本
- (void)reloadText;

@end
