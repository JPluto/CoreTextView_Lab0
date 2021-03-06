//
//  TextBase.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-27.
//  Copyright (c) 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextBaseView.h"

@implementation TextBaseView

@synthesize fontSize;
@synthesize lineHeight;
@synthesize lineSpace;
@synthesize fontName;
//@synthesize text;
@synthesize pageCount;

- (void)dealloc
{
//    [text release];
    [fontName release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //
    }
    return self;
}

- (CTFontRef)CreateItalicCTFont
{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[NSString stringWithFormat:@"%@-Italic", fontName], fontSize, NULL);
    if (fontRef == NULL) {
        fontRef = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    }
    
    return fontRef;
}

- (CTFontRef)CreateBoldCTFont
{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[NSString stringWithFormat:@"%@-Bold", fontName], fontSize, NULL);
    if (fontRef == NULL) {
        fontRef = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    }
    
    return fontRef;
}

- (CTFontRef)CreateNormalCTFont
{
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[NSString stringWithFormat:@"%@", fontName], fontSize, NULL);
    if (fontRef == NULL) {
        fontRef = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    }
    
    return fontRef;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
