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

- (void)initCoreTextParams;
- (void)loadVisibleTextForCFRange:(CFRange)rang;
- (void)reloadText;

@end
