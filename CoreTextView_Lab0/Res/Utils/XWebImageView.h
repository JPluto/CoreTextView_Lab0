//
//  UIImageView+Extension.h
//  TaduUtils
//
//  Created by Deheng Xu on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWebImageView;

@protocol XWebImageViewDownloadDelegate <NSObject>

@optional
- (void)webImageDownloaded:(XWebImageView *) xWebImageView;

@end

@interface XWebImageView : UIImageView {
    UIImage * image;
}

@property (nonatomic, retain) NSString * defaultIconName;
@property (nonatomic, retain) NSURLConnection * connection;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSMutableData * data;

@property (nonatomic, retain) UIActivityIndicatorView * activity;
@property (nonatomic, retain) NSObject<XWebImageViewDownloadDelegate> * delegate;
//非标准处理
@property (nonatomic) BOOL isNeedDecompress;
@property (nonatomic, retain) NSString * imageType;


- (void)updateImage:(BOOL) force;
- (void)startDownloading:(NSString *) sUrl;
- (void)stopDownloading;

@end
