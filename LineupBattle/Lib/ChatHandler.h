//
// Created by Anders Borre Hansen on 11/03/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firebase/Firebase.h"
#import "User.h"
#import "Message.h"


@interface ChatHandler : NSObject
@property(nonatomic) BOOL initialChatMessagesAdded;
@property(nonatomic) BOOL messageViewLoaded;
@property(nonatomic, strong) User *currentUser;
@property(nonatomic, strong) Firebase *firebase;
@property(nonatomic, strong, readonly) NSMutableArray *messages;
@property(nonatomic) NSUInteger messageCountNotFromCurrentUser;

- (instancetype)initFirebaseWithId:(NSString *)firebaseIdentifier;

- (void)updateMessagesReadCount;

- (NSInteger)getNumberOfUnreadMessages;

- (RACSignal *)observeMessagesChange;

- (NSString *)userNameForUserId:(NSString *)userId;

- (void)sendMessage:(NSString *)text;
- (void)addMessageToArray:(id)message;
- (void)setUserDictionary:(NSArray *)array;
- (Message *)messageWithText:(NSString *)text userId:(NSString *)userId;

@end