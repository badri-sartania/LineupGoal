//
// Created by Anders Hansen on 19/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//



#import "HTTP.h"
#import "HTTPHelper.h"
#import "CLSLogging.h"
#import "Configuration.h"


@implementation HTTP

+ (HTTP *)instance {
    static HTTP *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];

            NSURL *baseURL = [NSURL URLWithString:[Configuration instance].apiBaseUrl];
            _instance.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
            [_instance.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"InternetAvailable" object:self];
                        CLS_LOG(@"We have internet connection");
                        break;
                    case AFNetworkReachabilityStatusNotReachable:
                    default:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoInternet" object:self userInfo:@{
                            @"message": @"No internet connection"
                        }];
                        CLS_LOG(@"No internet connection");
                        break;
                }
            }];

            [_instance.manager.reachabilityManager startMonitoring];

            _instance.manager.requestSerializer = [AFJSONRequestSerializer serializer];
            [_instance.manager.requestSerializer setValue:[HTTPHelper userAgent] forHTTPHeaderField:@"User-Agent"];
        }
    }

    return _instance;
}

- (BOOL)isConnectionAvailable {
    return [self.manager.reachabilityManager isReachable];
}

- (AFHTTPRequestOperation *)get:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *paramsWithAuth = [HTTPHelper applyAuthToDictionary:params];

    return [self.manager GET:path
        parameters:paramsWithAuth
        success:^(AFHTTPRequestOperation *operation, id result) {
            success(result);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }
    ];
}

- (AFHTTPRequestOperation *)put:(NSString *)path params:(NSDictionary *)params body:(id)body success:(void(^)(id))success failure:(void(^)(NSError *))failure {
    NSString *pathWithParams = [HTTPHelper applyQuery:[HTTPHelper applyAuthToDictionary:params] toUrlString:path];
    return [self.manager PUT:pathWithParams
        parameters:body
        success:^(AFHTTPRequestOperation *operation, id result) {
           success(result);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }
    ];
}

- (AFHTTPRequestOperation *)post:(NSString *)path params:(NSDictionary *)params body:(id)body success:(void(^)(id))success failure:(void(^)(NSError *))failure {
    NSString *pathWithParams = [HTTPHelper applyQuery:[HTTPHelper applyAuthToDictionary:params] toUrlString:path];
    return [self.manager POST:pathWithParams
        parameters:body
        success:^(AFHTTPRequestOperation *operation, id result) {
            success(result);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }
    ];
}

@end
