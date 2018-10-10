//
//  Xcode7Macros.h
//  LineupBattle
//
//  Created by Anders Borre Hansen on 18/08/15.
//  Copyright (c) 2015 Pumodo. All rights reserved.
//

/**
* https://gist.github.com/smileyborg/d513754bc1cf41678054
* The following preprocessor macros can be used to adopt the new nullability annotations and generics
* features available in Xcode 7, while maintaining backwards compatibility with earlier versions of
* Xcode that do not support these features.
*/

#if __has_feature(nullability)
#   define __ASSUME_NONNULL_BEGIN      NS_ASSUME_NONNULL_BEGIN
#   define __ASSUME_NONNULL_END        NS_ASSUME_NONNULL_END
#   define __NULLABLE                  nullable
#else
#   define __ASSUME_NONNULL_BEGIN
#   define __ASSUME_NONNULL_END
#   define __NULLABLE
#endif

#if __has_feature(objc_generics)
#   define __GENERICS(class, ...)      class<__VA_ARGS__>
#   define __GENERICS_TYPE(type)       type
#else
#   define __GENERICS(class, ...)      class
#   define __GENERICS_TYPE(type)       id
#endif