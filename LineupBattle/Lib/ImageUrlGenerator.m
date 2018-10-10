//
// Created by Anders Borre Hansen on 03/02/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import "ImageUrlGenerator.h"
#import "Utils.h"
#import "Configuration.h"
#import "UIScreen+Util.h"


@implementation ImageUrlGenerator

+ (NSString *)playerPhotoImageUrlStringBySize:(NSString *)size photoToken:(NSString *)photoToken objectId:(NSString *)objectId {
    if (!photoToken || !objectId) return nil;
    return [self urlGeneratorWithBaseUrl:[[Configuration instance] playerAssetsBaseUrl] token:photoToken objId:objectId size:size ext:@".jpg"];
}

+ (NSString *)urlGeneratorWithBaseUrl:(NSString *)baseUrl token:(NSString *)token objId:(NSString *)objId size:(NSString *)size ext:(NSString *)ext {
    return [NSString stringWithFormat:@"%@/%@-%@-%@%@%@", baseUrl, objId, token, size, [ImageUrlGenerator imageResolutionString], ext];
}

+ (NSString *)imageResolutionString {
    if ([UIScreen retinaScreen2x]) {
        return @"@2x";
    } else if ([UIScreen retinaScreen3x]) {
        return @"@3x";
    }

    return @"";
}

@end
