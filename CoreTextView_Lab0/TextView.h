//
//  TextView.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-14.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBaseView.h"

@interface TextView : TextBaseView
{
@public
    CGFontRef cgFontRef;
    
}

@property (nonatomic, retain) UIFont * font;

@end
