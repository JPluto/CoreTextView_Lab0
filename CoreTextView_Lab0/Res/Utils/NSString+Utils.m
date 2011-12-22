//
//  NSString+Utils.m
//  WebViewCache
//
//  Created by Xu Nicholas on 11-7-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

//- (void)dealloc
//{
////    NSLog(@"Dealloc String+Utils");
//    [super dealloc];
//}


- (NSString*)md5Digest
{
	const char* cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH] = {
		0,
	};
	CC_MD5(cStr, strlen(cStr), result);
	
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

+ (NSString *)stringWithData:(NSData *)data usingEncoding:(NSStringEncoding)encoding
{
    return [[[NSString alloc] initWithData:data encoding:encoding] autorelease];
}

@end





@implementation NSMutableString (Utils)

- (NSString*)md5Digest
{
	const char* cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH] = {
		0,
	};
	CC_MD5(cStr, strlen(cStr), result);
	
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]];
}

@end
