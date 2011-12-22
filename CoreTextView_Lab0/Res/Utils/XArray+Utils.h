//
//  NSArray+Utils.h
//  TaduUtils
//
//  Created by Xu Nicholas on 11-8-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Utils)

- (id)objectForKey:(id)key atKeyPath:(NSString *)keyPath;

@end

@interface NSMutableArray (Utils)

- (id)objectForKey:(id)key atKeyPath:(NSString *)keyPath;
- (void)removeObjectForKey:(id)key atKeyPath:(NSString *)keyPath;

@end
