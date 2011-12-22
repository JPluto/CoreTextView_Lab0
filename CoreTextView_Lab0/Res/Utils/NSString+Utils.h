//
//  NSString+Utils.h
//  WebViewCache
//
//  Created by Xu Nicholas on 11-7-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSString (Utils)
- (NSString*)md5Digest;
+ (NSString*)stringWithData:(NSData *)data usingEncoding:(NSStringEncoding) encoding;

@end


@interface NSMutableString (Utils)

@end