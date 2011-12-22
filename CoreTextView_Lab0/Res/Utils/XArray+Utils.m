//
//  NSArray+Utils.m
//  TaduUtils
//
//  Created by Xu Nicholas on 11-8-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "XArray+Utils.h"

@implementation NSArray (Utils)


- (id)objectForKey:(id)key atKeyPath:(NSString *)keyPath
{
    for (NSObject * obj in self) {
        id value = [obj valueForKeyPath:keyPath];
        if (value && [value isEqual:key]) {
            return obj;
        }
    }
    return nil;
}

@end



@implementation NSMutableArray (Utils)


- (id)objectForKey:(id)key atKeyPath:(NSString *)keyPath
{
    for (NSObject * obj in self) {
        id value = [obj valueForKeyPath:keyPath];
        if (value && [value isEqual:key]) {
            return obj;
        }
    }
    return nil;
}

- (void)removeObjectForKey:(id)key atKeyPath:(NSString *)keyPath
{
    [self removeObject:[self objectForKey:key atKeyPath:keyPath]];
}


@end
