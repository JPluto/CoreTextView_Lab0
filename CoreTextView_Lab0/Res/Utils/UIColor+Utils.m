//
//  UIColor+Utils.m
//  TaduUtils
//
//  Created by Deheng.Xu on 11-7-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithARGB:(NSUInteger)argb;
{
	NSUInteger a, r, g, b;
	CGFloat base = 255.0;
	b = (argb & 0xff);
	g = ((argb >> 8) & 0xff);
	r = ((argb >> 16) & 0xff);
	a = ((argb >> 24) & 0xff);
	
	return [UIColor colorWithRed:r / base green:g / base blue:b / base alpha:a / base];
}

+ (UIColor *)colorWithAlpha:(NSUInteger)alpha Red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
	CGFloat base = 255.0;
	return [UIColor colorWithRed:red / base green:green / base blue:blue / base alpha:alpha / base];
}

@end
