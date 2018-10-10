//
// Created by Anders Borre Hansen on 03/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageUrlGenerator : NSObject
+ (NSString *)playerPhotoImageUrlStringBySize:(NSString *)size photoToken:(NSString *)photoToken objectId:(NSString *)objectId;

+ (NSString *)urlGeneratorWithBaseUrl:(NSString *)baseUrl token:(NSString *)token objId:(NSString *)objId size:(NSString *)size ext:(NSString *)ext;

+ (NSString *)imageResolutionString;
@end