//
//  TDSystemUtil.m
//  TaDuBookReader
//
//  Created by quancheng.wu on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDSystemUtil.h"

@implementation TDSystemUtil

//+(void) showNote:(NSString*)aMessage {
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:aMessage delegate:nil
//											  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
//}


+ (void)showNoteMessage:(NSString *)aMessage withDelegate:(id)delegate
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息" message:aMessage delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:nil] autorelease];
    [alert show];
}

+(NSString*) formateDate:(NSDate*)date formate:(NSString*) formate { 
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formate];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"H"]];
    return [dateFormatter stringFromDate:date];
}


@end
