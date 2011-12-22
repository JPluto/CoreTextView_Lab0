//
//  XUtils.m
//  LionLibs
//
//  Created by NicholasXu on 11-5-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XUtils.h"
#import "RegexKitLite.h"

@implementation XUtils

static NSMutableDictionary * _encodings = nil;
@synthesize foundSubviews;

+ (void)printArray:(NSArray *)anArray
{
    if (!anArray) {
        NSLog(@"print array is null!");
        return;
    }
    int i = 0;
    for (NSObject * obj in anArray) {
        NSLog(@"ClassName:%@; index:%d; rtc:%u; value:[%@]", [obj classForCoder], i, [obj retainCount], obj);
        i ++;
    }
}

+ (void)printArray:(NSArray *)anArray ToDestinateString:(NSString **)aDestString
{
    NSMutableString * str = [NSMutableString string];
    int  i = 0;
    for (NSObject * obj in anArray) {
        [str appendFormat:@"ClassName:%@; index:%d; value:%@\n", [obj classForCoder], i, obj];
        i ++;
    }
    (*aDestString) = str;
}

+ (BOOL)isSimulator
{
    //NSLog(@"%@ [MODEL:] %@", DEBUG_FUNCTION_NAME, [[UIDevice currentDevice] model], [[[UIDevice currentDevice] model] stringByMatching:@"Simulator"]);
    return [[[[[UIDevice currentDevice] model] lowercaseString] stringByMatching:@"simulator"] length] > 0;
}

+ (BOOL)isIPhone
{
    //NSLog(@"%@ [MODEL:] %@", DEBUG_FUNCTION_NAME, [[UIDevice currentDevice] model], [[[UIDevice currentDevice] model] stringByMatching:@"Simulator"]);
    return [[[[[UIDevice currentDevice] model] lowercaseString] stringByMatching:@"iphone"] length] > 0;
}

+ (BOOL)isIPad
{
    //NSLog(@"%@ [MODEL:] %@", DEBUG_FUNCTION_NAME, [[UIDevice currentDevice] model], [[[UIDevice currentDevice] model] stringByMatching:@"Simulator"]);
    return [[[[[UIDevice currentDevice] model] lowercaseString] stringByMatching:@"ipad"] length] > 0;
}

+ (BOOL)isIPod
{
    //NSLog(@"%@ [MODEL:] %@", DEBUG_FUNCTION_NAME, [[UIDevice currentDevice] model], [[[UIDevice currentDevice] model] stringByMatching:@"Simulator"]);
    return [[[[[UIDevice currentDevice] model] lowercaseString] stringByMatching:@"ipod"] length] > 0;
}

- (id) init
{
	self = [super init];
	if (!_encodings) {
		[self encodingSet];
	}
	return self;
}

static XUtils * _utils = nil;
+ (XUtils *) instance {
	if (!_utils) {
		_utils = [XUtils new];
	}
	return _utils;
}

+ (UIImage *)loadImageWithName:(NSString *)name Type:(NSString *)type
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]];
}

- (NSString *)faviconUrlStringFromHtml:(NSString *)htmlContent andUrl:(NSString *)urlString
{
    NSString * iconFilter = [NSString stringWithString:@"href=\"([a-zA-Z$/.:0-9]){0,}([.]ico)"];
    
    NSString * shortcut = [htmlContent stringByMatching:@"shortcut icon"];
    NSMutableString * iconUrlStr = [NSMutableString string];
    NSMutableString * rootUrl = [NSMutableString string];
    NSArray * pathComps = [urlString pathComponents];
    NSString * iconPath = [htmlContent stringByMatching:iconFilter];
	//    remove href\" prefix
    iconPath = [iconPath stringByReplacingOccurrencesOfRegex:@"href[ ]{0,}=[ ]{0,}\"[ ]{0,}" withString:@""];
	//    NSLog(@"shortcut=%@; iconPath=%@", shortcut, iconPath);
    [rootUrl appendFormat:@"%@//", [pathComps objectAtIndex:0]];
    [rootUrl appendFormat:@"%@", [pathComps objectAtIndex:1]];
	//    NSLog(@"rootUrl=%@;   iconUrlStr=%@", rootUrl, iconUrlStr);
    if (shortcut) {
        if (!iconPath) {
            return nil;
        }
        [iconUrlStr setString:iconPath];
        if (![iconUrlStr stringByMatching:@"^http[s]{0,}"]) {
            [iconUrlStr insertString:rootUrl atIndex:0];
        }
        
    }else {
        [iconUrlStr appendFormat:@"%@/favicon.ico", rootUrl];
    }
	//    NSLog(@"shortcut:%@  iconUrl:%@", shortcut, iconUrlStr);
    return iconUrlStr;
}

- (NSDictionary *)encodingSet
{
	if (!_encodings) {
		_encodings = [NSMutableDictionary dictionary];
		_encodings = [NSMutableDictionary new];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:NSASCIIStringEncoding] forKey:@"ascii"];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:NSUTF8StringEncoding] forKey:@"utf-8"];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:NSUnicodeStringEncoding] forKey:@"unicode"],
		[_encodings setObject:[NSNumber numberWithUnsignedLong:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] forKey:@"gbk"];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] forKey:@"gb2312"];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] forKey:@"gbk18030"];
		[_encodings setObject:[NSNumber numberWithUnsignedLong:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)] forKey:@"big5"];
	}
	return _encodings;
}

- (NSString *)findCorrectHtmlStringFrom:(NSData *)dataBuffer andTextEncoding:(NSString *)responseEncoding
{
    
    NSString * html = [[NSString alloc] initWithData:dataBuffer encoding:NSASCIIStringEncoding];
    NSString * enc = nil;
    enc = [html stringByMatching:@"charset=(([a-zA-Z0-9-\"])*)"];
	enc = [enc stringByReplacingOccurrencesOfRegex:@"\"" withString:@""];
	enc = [enc stringByReplacingOccurrencesOfRegex:@"charset=" withString:@""];
	
	if (!enc) {
		enc = [html stringByMatching:@"encoding=(([a-zA-Z0-9-\"])*)"];
		enc = [enc stringByReplacingOccurrencesOfRegex:@"\"" withString:@""];
		enc = [enc stringByReplacingOccurrencesOfRegex:@"encoding=" withString:@""];
	}
	
	enc = [enc lowercaseString];
	responseEncoding = [responseEncoding lowercaseString];
	//    NSLog(@"enc = %@; responseEncoding = %@", enc, [html stringByMatching:@"encoding=(([a-zA-Z0-9-\"])*)"]);
    
    [html release];
	
    if (!responseEncoding && !enc) {
		html = [[NSString alloc] initWithData:dataBuffer encoding:NSUTF8StringEncoding];
    }else if (responseEncoding) {
        html = [[NSString alloc] initWithData:dataBuffer encoding:[[[self encodingSet] objectForKey:responseEncoding] unsignedLongValue]];
    }else if (enc) {
        html = [[NSString alloc] initWithData:dataBuffer encoding:[[[self encodingSet] objectForKey:enc] unsignedLongValue]];
    }
    return [html autorelease];
}

- (NSString *) findCorrectHtmlEncodingNameFrom:(NSData *) dataBuffer
{
    NSString * html = [[NSString alloc] initWithData:dataBuffer encoding:NSASCIIStringEncoding];
    NSString * enc = nil;
    enc = [html stringByMatching:@"charset=(([a-zA-Z0-9-\"])*)"];
	enc = [enc stringByReplacingOccurrencesOfRegex:@"\"" withString:@""];
	enc = [enc stringByReplacingOccurrencesOfRegex:@"charset=" withString:@""];
	
	if (!enc) {
		enc = [html stringByMatching:@"encoding=(([a-zA-Z0-9-\"])*)"];
		enc = [enc stringByReplacingOccurrencesOfRegex:@"\"" withString:@""];
		enc = [enc stringByReplacingOccurrencesOfRegex:@"encoding=" withString:@""];
	}
	
	enc = [enc lowercaseString];
	//	responseEncoding = [responseEncoding lowercaseString];
	//    NSLog(@"enc = %@; responseEncoding = %@", enc, [html stringByMatching:@"encoding=(([a-zA-Z0-9-\"])*)"]);
    
    [html release];
	
    if (!enc) {
		return @"utf-8";
    }else if (enc) {
        //html = [[NSString alloc] initWithData:dataBuffer encoding:[[[self encodingSet] objectForKey:enc] unsignedLongValue]];
		return enc;
    }
	return enc;
}

- (NSStringEncoding) findCorrectHtmlStringEncodingFrom:(NSData *)data andTextEncoding:(NSString *)responseEncoding
{
	NSString * encStr = [self findCorrectHtmlStringFrom:data andTextEncoding:responseEncoding];
	return (NSStringEncoding)[[_encodings objectForKey:encStr] unsignedLongValue];
}

- (NSDictionary *) fontFamily
{
	NSArray *fonts = [UIFont familyNames];
	NSMutableDictionary *allFonts = [NSMutableDictionary new];
	for (NSString * familyName in fonts) {
		[allFonts setObject:[UIFont fontNamesForFamilyName:familyName] forKey:familyName];
	}
	[allFonts writeToFile:@"/iphon4_font_family.plist" atomically:YES];
	printf("Notice! Has already written file iphon4_font_family in \"/\"");
	return [allFonts autorelease];	
}

static NSArray *dateformatters = nil;

- (NSDate*)dateFromString:(NSString*) sDate
{
	if (dateformatters == nil) {
		dateformatters = [[NSArray alloc] initWithObjects:
						  @"EEE, dd MMM yyyy hh:mm:ss z",
						  @"EEE, dd MMM yyyy h:m:s z",
						  @"EEE, dd MMM yyyy H:m:s z",
						  @"EEE, d MMM yyyy HH:m:s z",
						  @"EEE, dd MMM yyyy",
						  @"EEE, MMM dd yyyy hh:mm:ss",
						  @"EEE, MMM dd yyyy H:mm:ss",
						  @"EEE, MMM dd yyyy H:mm:ss",
						  @"yyyy-mm-dd hh:mm:ss",
						  @"yyyy-mm-dd HH:mm:ss",
						  @"yyyy-mm-dd hh:mm:ss EEE",
						  nil];
	}
	NSDateFormatter *format =  [NSDateFormatter new];
	NSDate *date = nil;
	[format setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
	for (int i = 0; i < [dateformatters count]; i++) {
		[format setDateFormat:[dateformatters objectAtIndex:i]];
		date = [format dateFromString:sDate];
		if (date) {
			break;
		}
	}
	[format release];
	return date;
}

- (BOOL)checkResponderIfCompressed:(NSDictionary *)responseHeaders
{
    NSArray * keys  = [NSArray arrayWithObjects:@"Content-Type", @"Content-Encoding", @"Data-Encoding", nil];
    for (NSString * theKey in keys) {
        if ([[responseHeaders valueForKey:theKey] rangeOfString:@"gzip"].length > 0) {
            return YES;
        }
        if ([[responseHeaders valueForKey:theKey] rangeOfString:@"x-gzip"].length > 0) {
            return YES;
        }
    }
    return NO;
}


/////////////////// 打印视图层级结构
int level = -1;
NSMutableString * tabString = nil;

- (void)resetDataForTravelingSubviews 
{
    SafeRelease(tabString);
    SafeRelease(foundSubviews);
    tabString = [NSMutableString new];
    foundSubviews = [NSMutableArray new];
    level = -1;
}

- (void)travelSubviews:(UIView *) view {
    level ++;
    [tabString appendString:@" "];
    UIView * testView = nil;
    for (int i = 0; i < [[view subviews] count]; i++) {
        testView = [[view subviews] objectAtIndex:i];
        NSLog(@"%@:%@ %@ %@", tabString, [testView class], NSStringFromCGRect(testView.frame), XUStringFromBool(testView.clipsToBounds));
        [self travelSubviews:testView];
    }
    level--;
    if (level > 0) {
        [tabString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
}

- (void)findSubview:(UIView *)view WithName:(NSString *)name
{
    level ++;
    //if (level > 0) [tabString appendString:@" "];
    UIView * testView = nil;
    for (int i = 0; i < [[view subviews] count]; i++) {
        testView = [[view subviews] objectAtIndex:i];
        if ([NSStringFromClass([testView class]) hasPrefix:name]) {
            [foundSubviews addObject:testView];
        }
        //NSLog(@"%@:%@ %@;  match:%@", tabString, NSStringFromClass([testView class]), NSStringFromCGRect(testView.frame), XUStringFromBool([NSStringFromClass([testView class]) hasPrefix:name]));
        [self findSubview:testView WithName:name];
    }
    level--;
    //if (level > 0) {
    //    [tabString deleteCharactersInRange:NSMakeRange(0, 1)];
    //}
}

@end
