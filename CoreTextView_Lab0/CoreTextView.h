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
    CFMutableAttributedStringRef cfAttrStringRef;
    CFRange visibleRange;
    CTFrameRef visibleFrameRef;
    CGRect visibleBounds;
    
    CFArrayRef ctLinesArrayRef;
    CFIndex startGlyphIndex;
    CFIndex totalGlyphCount;
    CGRect selectedRect;
    
    CFIndex selectedStartIndex;
    CFIndex selectedEndIndex;
    CFIndex selectedStartLine;
    CFIndex selectedEndLine;
    
    CGContextRef m_Context;
	
}


- (void)loadVisibleTextForCFRange:(CFRange)rang;

@end
