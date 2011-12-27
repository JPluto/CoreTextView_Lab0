//
//  UIColor+Utils.h
//  TaduUtils
//
//  Created by Deheng.Xu on 11-7-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (Utils)

+ (UIColor *)colorWithARGB:(NSUInteger)argb;
+ (UIColor *)colorWithAlpha:(CGFloat)alpha Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
