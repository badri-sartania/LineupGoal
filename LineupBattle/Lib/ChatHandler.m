//
// Created by Anders Borre Hansen on 11/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <BlocksKit/NSArray+BlocksKit.h>
#import "ChatHandler.h"
#import "Identification.h"


#define kFirechatNS @"https://vivid-fire-7939.firebaseio.com/"

@interface ChatHandler ()
@property(nonatomic, copy) NSString *firebaseIdentifier;
@property(nonatomic, strong) NSDictionary *users;
@end

@implementation ChatHandler

#pragma mark - Chat
- (instancetype)initFirebaseWithId:(NSString *)firebaseIdentifier {
    self = [super init];

    if (self) {
        self.users = @{};
        _messages = [[NSMutableArray alloc] init];
        self.messageCountNotFromCurrentUser = 0;

        // Initialize the root of our Firebase namespace.
        self.firebaseIdentifier = firebaseIdentifier;
        self.firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", kFirechatNS, firebaseIdentifier]];
        [self.firebase authAnonymouslyWithCompletionBlock:^(NSError *error, FAuthData *authData) {}];

        // Value event fires right after we get the events already stored in the Firebase repo.
        // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
        @weakify(self);
        [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            @strongify(self);
            self.initialChatMessagesAdded = YES;
        }];

        [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            @strongify(self);

            NSDictionary *dic = snapshot.value;

            // Create message obj
            Message *message = [self messageWithText:dic[@"text"] userId:dic[@"userId"]];

            // Update counter and insert message to array if message do not belongs to user
            if (![self isUser:dic[@"userId"]]) {
                self.messageCountNotFromCurrentUser++;
            }

            // Only insert message if not from you unless initial seed
            if (!self.initialChatMessagesAdded || !self.messageViewLoaded || ![self isUser:dic[@"userId"]]) {
                // Use special insert KV method to detect change in array
                [self addMessageToArray:message];
            }
        }];
    }

    return self;
}

- (Message *)messageWithText:(NSString *)text userId:(NSString *)userId {
    Message *message = [Message new];
    message.username = [self userNameForUserId:userId];
    message.text = text;
    message.profileUrl = [self profileImageUrlForUserId:userId];

    return message;
}

- (void)addMessageToArray:(id)message {
    NSMutableArray *contents = [self mutableArrayValueForKey:@keypath(self, messages)];
    [contents insertObject:message atIndex:0];
}

- (BOOL)isUser:(NSString *)userId {
    return [userId isEqualToString:[Identification userId]];
}

#pragma mark - Changes
- (RACSignal *)observeMessagesChange {
    return [[self rac_valuesAndChangesForKeyPath:@keypath(self, messages) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld observer:nil] replayLast];
}

#pragma mark - User handling
- (NSString *)userNameForUserId:(NSString *)userId {
    return [self.users[userId] name] ?: @"Anonymous";
}

- (NSString *)profileImageUrlForUserId:(NSString *)userId {
    return [self.users[userId] profileImagePath:34];
}

- (void)sendMessage:(NSString *)text {
    [[self.firebase childByAutoId] setValue:@{
        @"userId": [Identification userId],
        @"text": text
    }];
}

// Takes users from a battle and creates a dictionary of user ids.
// Used to look up user ids from firebase objs.
- (void)setUserDictionary:(NSArray *)users {
    NSMutableDictionary *usersDic = [[NSMutableDictionary alloc] initWithCapacity:users.count];

    [users bk_each:^(User *user) {
        usersDic[user.objectId] = user;
    }];

    self.users = usersDic;
}

#pragma mark - Message Count
- (void)updateMessagesReadCount {
    [[NSUserDefaults standardUserDefaults] setInteger:self.messageCountNotFromCurrentUser forKey:self.battleCountKey];
}

- (NSInteger)getNumberOfUnreadMessages {
    NSInteger readCount = [[NSUserDefaults standardUserDefaults] integerForKey:self.battleCountKey];
    return self.messageCountNotFromCurrentUser - readCount;
}

#pragma mark - Helpers
- (NSString *)battleCountKey {
    return [NSString stringWithFormat:@"battleCount%@", self.firebaseIdentifier];
}

@end
