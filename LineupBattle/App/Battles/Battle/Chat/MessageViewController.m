//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Modified by Anders Borre Hansen
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "MessageTextView.h"
#import <JGProgressHUD/JGProgressHUD.h>

static NSString *MessengerCellIdentifier = @"MessengerCell";

@interface MessageViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) ChatHandler *chatHandler;
@end

@implementation MessageViewController

- (id)initWithChatHandler:(ChatHandler *)chatHandler {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        self.chatHandler = chatHandler;
        self.title = @"Group Chat";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeChat)];

        [self commonInit];
    }
    return self;
}

- (void)closeChat {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder {
    return UITableViewStylePlain;
}

- (void)commonInit {
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
    [self registerClassForTextView:[MessageTextView class]];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.chatHandler.messageViewLoaded = YES;

    self.messages = [self.chatHandler.messages mutableCopy] ?: [[NSMutableArray alloc] init];
    [self.chatHandler updateMessagesReadCount];


    @weakify(self);
    [[self.chatHandler observeMessagesChange] subscribeNext:^(RACTuple *arrayChange){
        @strongify(self);
        if (self.chatHandler.initialChatMessagesAdded) {
            self.messages = [arrayChange.first mutableCopy];
            [self.chatHandler updateMessagesReadCount];
            [self addMessageToEndOfTableView];
        }
    }];

    self.bounces = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.inverted = YES;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:MessengerCellIdentifier];

    [self.rightButton setTitle:@"Send" forState:UIControlStateNormal];

    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0]];

    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 512;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
}

#pragma mark - Overridden Methods
- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status {
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate {
    // Notifies the view controller that the text will update.
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated {
    // Notifies the view controller that the text did update.
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender {
    // Notifies the view controller when the left button's action has been triggered, manually.
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender {
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];

    Message *message = [self.chatHandler messageWithText:[self.textView.text copy] userId:self.chatHandler.currentUser.objectId];

    [self.chatHandler sendMessage:message.text];
    [self.chatHandler addMessageToArray:message];

    [super didPressRightButton:sender];
}

- (void)addMessageToEndOfTableView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;

    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];

    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];

    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)keyForTextCaching {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (BOOL)canPressRightButton {
    return [super canPressRightButton];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableView]) {
        return self.messages.count;
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self messageCellForRowAtIndexPath:indexPath];
}

- (MessageTableViewCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = (MessageTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:MessengerCellIdentifier];
    Message *message = self.messages[(NSUInteger)indexPath.row];

    cell.titleLabel.text = message.username;
    cell.bodyLabel.text = message.text;

    cell.indexPath = indexPath;
    cell.usedForMessage = YES;

    [cell.thumbnailView loadImageWithUrlString:message.profileUrl placeholder:@"playerPlaceholder"];

    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.tableView]) {
        Message *message = self.messages[(NSUInteger)indexPath.row];

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;

        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                     NSParagraphStyleAttributeName: paragraphStyle};

        CGFloat width = CGRectGetWidth(tableView.frame)-kMessageTableViewCellAvatarHeight;
        width -= 25.0;

        CGRect titleBounds = [message.username boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
        CGRect bodyBounds = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];

        if (message.text.length == 0) {
            return 0.0;
        }

        CGFloat height = CGRectGetHeight(titleBounds);
        height += CGRectGetHeight(bodyBounds);
        height += 20.0;

        if (height < kMessageTableViewCellMinimumHeight) {
            height = kMessageTableViewCellMinimumHeight;
        }

        return height;
    }
    else {
        return kMessageTableViewCellMinimumHeight;
    }
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - UIScrollViewDelegate Methods
/** UITextViewDelegate */
- (BOOL)textView:(SLKTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [super textView:textView shouldChangeTextInRange:range replacementText:text];
}

@end
