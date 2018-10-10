//
// Created by Anders Borre Hansen on 27/01/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "NSDictionary+UrlEncodedString.h"
#import "Utils.h"

// helper function: get the string form of any object
static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef) string,
            NULL,
            (CFStringRef) @"!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

@implementation NSDictionary (UrlEncodedString)

- (NSString *)urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = self[key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end