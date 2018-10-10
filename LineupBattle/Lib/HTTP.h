//
// Created by Anders Hansen on 19/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subscription.h"
#import "AFHTTPRequestOperationManager.h"


@interface HTTP : NSObject
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;

+ (HTTP *)instance;

- (BOOL)isConnectionAvailable;

- (AFHTTPRequestOperation *)get:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)put:(NSString *)string params:(NSDictionary *)params body:(id)body success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)post:(NSString *)path params:(NSDictionary *)params body:(id)body success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
