//
//  NSDictionary+printChinese.m
//  FKSlideMenuDemo
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "NSDictionary+printChinese.h"

@implementation NSDictionary (printChinese)
- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *mString = [NSMutableString string];
    [mString appendString:@"{"];
    for (id key in self) {
        [mString appendFormat:@"\n\t%@ = %@,", key, self[key]];
    }
    [mString appendString:@"\n}"];
    return mString;
}

@end
