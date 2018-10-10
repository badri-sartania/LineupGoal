//
// Created by Anders Hansen on 21/03/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import <Helpshift/HelpshiftSupport.h>
#import "MoreTableViewController.h"
#import "DefaultViewCell.h"
#import "DefaultNavigationController.h"
#import "InfoViewController.h"
#import "SimpleLocale.h"


@interface MoreTableViewController ()
@property (nonatomic, strong) NSArray *cells;
@end

@implementation MoreTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];

    if (self) {
        self.title = @"More";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.cells = @[
            @{
                @"imageName": @"more_shout",
                @"title": @"Share Lineup Battle",
                @"action": @"shareLineupbattle"
            },
            @{
                @"imageName": @"more_globe",
                @"title": @"Get News & Updates",
                @"action": @"openFacebookLink"
            },
            @{
                @"imageName": @"more_star",
                @"title": @"Review Lineup Battle",
                @"link": @"https://itunes.apple.com/app/id984899524?ls=1&mt=8"
            },
            @{
                @"imageName": @"more_question",
                @"title": @"FAQ",
                @"action": @"openFAQ"
            },
            @{
                @"imageName": @"more_bubble",
                @"title": @"Help & Feedback",
                @"action": @"openFeedback"
            }
        ];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(infoTableView)];
}

- (void)infoTableView {
    InfoViewController *infoViewController = [[InfoViewController alloc] init];
    DefaultNavigationController *navigationController = [[DefaultNavigationController alloc] initWithRootViewController:infoViewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)openFeedback {
    [HelpshiftSupport showConversation:self withOptions:nil];
}

- (void)openFAQ {
    [HelpshiftSupport showFAQs:self withOptions:nil];
}

- (void)openFacebookLink {
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/935676493131713"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/lineupbattle"]];
    }
}

- (void)shareLineupbattle {
    NSString *message = [NSString stringWithFormat:@"Check out Lineup Battle for iOS - Pick players. Battle fans. Daily fantasy %@ action!", [SimpleLocale USAlternative:@"soccer" forString:@"football"]];
    NSURL *URL = [NSURL URLWithString:@"http://bit.ly/lineupbattle"];

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[message, URL] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:^{}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DefaultViewCell *cell = [[DefaultViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    NSString *title = self.cells[(NSUInteger)indexPath.row][@"title"];
    NSString *imageName = self.cells[(NSUInteger)indexPath.row][@"imageName"];

    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:imageName];

    if (indexPath.row == self.cells.count - 1) {
        cell.detailTextLabel.text = @"We are really friendly";
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *item = self.cells[(NSUInteger)indexPath.row];

    if (item[@"link"]) {
        NSURL *url = [NSURL URLWithString:item[@"link"]];
        [[UIApplication sharedApplication] openURL:url];
    } else if (item[@"action"]) {
        SEL s = NSSelectorFromString(item[@"action"]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:s];
#pragma clang diagnostic pop
    }
}

@end
