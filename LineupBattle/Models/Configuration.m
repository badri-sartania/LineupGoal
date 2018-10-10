//
// Created by Anders Hansen on 28/01/14.
// Copyright (c) 2014 xip. All rights reserved.
//

#import "Configuration.h"
#import "HTTP.h"
#import "Utils.h"
#import "HTTP+RAC.h"

@implementation Configuration

+ (Configuration *)instance {
    static Configuration *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

+ (void)clearConfigurationIfAppUpdated {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    NSString *lastLaunchedBuild = [settings objectForKey:@"LastLaunchedBuild"];
    NSString *currentBuild = infoDictionary[(NSString *) kCFBundleVersionKey];

    if (![currentBuild isEqualToString:lastLaunchedBuild]) {
        [settings setObject:currentBuild forKey:@"LastLaunchedBuild"];

        // Clear the cache for /config in case of app-update.
        NSURL *url = [NSURL URLWithString:[[[Configuration instance] apiBaseUrl] stringByAppendingString:@"/config"]];
        NSURLRequest *endpoint = [NSURLRequest requestWithURL:url];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:endpoint];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
		#if DEBUG
			_apiBaseUrl = @"https://api.goalfury.com";
		#else
			_apiBaseUrl = [Utils stringInMainBundleForKey:@"LineupBattleBaseURL"];
		#endif
        [self loadConfiguration];
    }

    return self;
}

- (void)loadConfiguration {
    [self loadConfigurationFromCache];

    @weakify(self);
    [[HTTP instance] fetchConfiguration:^(id response) {
        @strongify(self);
        [self updateConfiguration:response];
    }];
}

- (void)updateConfiguration:(NSDictionary *)config {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *configCache = [(NSDictionary *) [settings objectForKey:@"configuration"] mutableCopy];

    if (!configCache)
        configCache = [[NSMutableDictionary alloc] initWithCapacity:3];

    if (config[@"url"][@"player"])
        configCache[@"PlayerAssetsBaseUrl"]      = config[@"url"][@"player"];
    if (config[@"url"][@"club"])
        configCache[@"ClubAssetsBaseUrl"]        = config[@"url"][@"club"];
    if (config[@"url"][@"competition"])
        configCache[@"CompetitionAssetsBaseUrl"] = config[@"url"][@"competition"];
    if (config[@"url"][@"users"])
        configCache[@"UsersAssetsBaseUrl"]       = config[@"url"][@"users"];

    [settings setObject:configCache forKey:@"configuration"];

    [self loadConfigurationFromCache];
}

- (void)loadConfigurationFromCache {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary *cache = [settings objectForKey:@"configuration"];

    NSString *assetBaseUrl = @"http://d8bkrgqy38wk0.cloudfront.net/v2";

    _playerAssetsBaseUrl      = cache[@"PlayerAssetsBaseUrl"]      ?: [assetBaseUrl stringByAppendingString:@"/players"];
    _clubAssetsBaseUrl        = cache[@"ClubAssetsBaseUrl"]        ?: [assetBaseUrl stringByAppendingString:@"/teams"];
    _competitionAssetsBaseUrl = cache[@"CompetitionAssetsBaseUrl"] ?: [assetBaseUrl stringByAppendingString:@"/competitions"];
    _usersAssetsBaseUrl       = cache[@"UsersAssetsBaseUrl"]       ?: @"http://s3-eu-west-1.amazonaws.com/pumodo-lb-prod/v1/users";
}

@end
