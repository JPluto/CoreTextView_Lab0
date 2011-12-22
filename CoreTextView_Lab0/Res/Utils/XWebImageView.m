//
//  UIImageView+Extension.m
//  TaduUtils
//
//  Created by Deheng Xu on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "XWebImageView.h"

@implementation XWebImageView

@synthesize connection;
@synthesize imageUrl;
@synthesize data;
@synthesize defaultIconName;
@synthesize activity;
@synthesize delegate;
@synthesize isNeedDecompress;
@synthesize imageType;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        defaultIconName = [[NSString alloc] initWithFormat:@"暂无封面.png"];
        self.image = [UIImage imageNamed:defaultIconName];
        if (activity == nil) {
            activity = [UIActivityIndicatorView new];
        }
        activity.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview:self.activity];
        [activity setHidden:YES];
    }
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		defaultIconName = [[NSString alloc] initWithFormat:@"暂无封面.png"];
        self.image = [UIImage imageNamed:defaultIconName];
        if (activity == nil) {
            activity = [UIActivityIndicatorView new];
        }
        activity.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
        [self addSubview:self.activity];
        [activity setHidden:YES];
    }
    return self;
}

- (void) updateImage:(BOOL)force
{
    //NSLog(@"force :%@", XUStringFromBool(force));
	
	if (force) {
		[self startDownloading:imageUrl];
	}else {
		BOOL loadDefault = YES;
        //NSLog(@"Fav:%@", favorite);
        if (imageUrl) {
            [self startDownloading:imageUrl];
        }
		
		if (loadDefault && defaultIconName.length > 0) {//调用默认值
			//NSLog(@"加载默认封面:%@", defaultIconName);
            self.image = [UIImage imageNamed:defaultIconName];
		}
		
	}
}

- (void) startDownloading:(NSString *)sUrl
{
    [self.activity setHidden:NO];
	data = [NSMutableData new];
	NSLog(@"start downloading image:%@", sUrl);
    if (!sUrl) {
        NSLog(@"%@ url is nil!", DEBUG_FUNCTION_NAME);
        return;
    }
	NSURL * url = [[NSURL alloc] initWithString:sUrl];
    NSMutableURLRequest * muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [muRequest setTimeoutInterval:60.0f];
	connection = [[NSURLConnection alloc] initWithRequest:muRequest delegate:self];
	[url release];
	[muRequest release];
}

- (void)stopDownloading
{
    if (connection) {
        [connection cancel];
        SafeRelease(connection);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	[connection cancel];
    SafeRelease(connection);
    SafeRelease(imageUrl);
    SafeRelease(data);
    SafeRelease(defaultIconName);
    SafeRelease(activity);
    SafeRelease(imageType);
    
    SafeRelease(delegate);//非标准处理
    [super dealloc];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//NSLog(@"error:%@", error);
    if (error) {
        self.data = nil;
        [self.activity setHidden:YES];
    }
}
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse * httpRespon = (NSHTTPURLResponse *) response;
        //NSLog(@"XWebImageView response %@", [httpRespon allHeaderFields]);
        self.imageType = [httpRespon.allHeaderFields objectForKey:@"Content-Type"];
        isNeedDecompress = [[XUtils instance] checkResponderIfCompressed:httpRespon.allHeaderFields];
    }else {
        //NSLog(@"response class:%@", [response classForCoder]);
    }
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData
{
    if (data != nil) {
        [self.data appendData:aData];
    }
	//NSLog(@"%@ %d/%d", DEBUG_FUNCTION_NAME, [aData length], [self.data length]);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSLog(@"%@ connection:%@", DEBUG_FUNCTION_NAME, self.connection);
    if (self.connection == nil) {
        return;
    }
	self.connection = nil;
	UIImage * img = [[[UIImage alloc] initWithData:self.data] autorelease];
    //NSLog(@"img = %@", img);
	if (img == nil || self.data.length <= 0) {
		img = [UIImage imageNamed:defaultIconName];
	}
	
	self.image = img;
    
    //进行相应处理
    
    if (delegate && [delegate respondsToSelector:@selector(webImageDownloaded:)]) {
        [delegate webImageDownloaded:self];
    }
	
    [self.activity setHidden:YES];
}

- (void) setImage:(UIImage *) aImage
{
	if (image == nil) {
        if (defaultIconName.length == 0) {
            image = nil;
            return;
        }
        image = [UIImage imageNamed:defaultIconName];
	}else {
		[super setImage:aImage];
	}
	
	//NSLog(@"%@ :%@; self size:%@", DEBUG_FUNCTION_NAME, NSStringFromCGSize(image.size), NSStringFromCGSize(self.frame.size));
}

@end
