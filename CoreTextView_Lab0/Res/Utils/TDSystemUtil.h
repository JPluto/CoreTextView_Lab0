//
//  TDSystemUtil.h
//  TaDuBookReader
//
//  Created by quancheng.wu on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TDBookInfo;

@interface TDSystemUtil : NSObject {

}

+(void) showNoteMessage:(NSString *)aMessage withDelegate:(id) delegate;
+(NSString*) formateDate:(NSDate*)date formate:(NSString*)formate;


@end
