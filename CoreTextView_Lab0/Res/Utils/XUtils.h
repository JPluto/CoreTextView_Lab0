//
//  XUtils.h
//  LionLibs
//
//  Created by NicholasXu on 11-5-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SafeRelease//(obj)
#define SafeRelease(obj) {[obj release]; obj = nil;}
#endif

#ifndef APP_FRAME
#define APP_FRAME [[UIScreen mainScreen] applicationFrame]
#endif

#ifndef APP_BOUNDS
#define APP_BOUNDS [[UIScreen mainScreen] bounds]
#endif

#ifndef XUStringFromBool//(value)
#define XUStringFromBool(value) ((value) ? @"YES" : @"NO")
#endif

#define JS_HTML_TITLE    @"document.title"
#define JS_HTML_BODY     @"document.documentElement.innerHTML"

#define DEBUG_FUNCTION_NAME [NSString stringWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]
#define DEBUG_FILE_NAME [NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding]

#define OUT_FUNCTION_NAME()  NSLog(@"%@ addr:%u", DEBUG_FUNCTION_NAME, (NSUInteger)self)

@interface XUtils : NSObject {

}
@property (nonatomic, retain) NSMutableArray * foundSubviews;

+ (void)printArray:(NSArray *)anArray;
+ (void)printArray:(NSArray *)anArray ToDestinateString:(NSString **)aDestString;
+ (XUtils *) instance;
+ (UIImage *) loadImageWithName:(NSString *) name Type:(NSString *) type;
+ (BOOL)isSimulator;
+ (BOOL)isIPhone;
+ (BOOL)isIPad;
+ (BOOL)isIPod;


- (NSString *)faviconUrlStringFromHtml:(NSString *)htmlContent andUrl:(NSString *)urlString;
- (NSString *)findCorrectHtmlStringFrom:(NSData *)data andTextEncoding:(NSString *)responseEncoding;
- (NSStringEncoding)findCorrectHtmlStringEncodingFrom:(NSData *)data andTextEncoding:(NSString *)responseEncoding;
- (NSString *)findCorrectHtmlEncodingNameFrom:(NSData *)data;
- (NSDictionary *)encodingSet;

- (NSDictionary *)fontFamily;
- (NSDate*)dateFromString:(NSString*) sDate;
- (BOOL)checkResponderIfCompressed:(NSDictionary *)responseHeaders;

- (void)resetDataForTravelingSubviews;
- (void)travelSubviews:(UIView *) view;
- (void)findSubview:(UIView *)view WithName:(NSString *)name;

@end
