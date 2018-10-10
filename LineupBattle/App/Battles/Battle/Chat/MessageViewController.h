//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "ChatHandler.h"
#import "Message.h"


@interface MessageViewController : SLKTextViewController
@property(nonatomic, strong) Message *lastMessage;

- (id)initWithChatHandler:(ChatHandler *)chatHandler;
@end
