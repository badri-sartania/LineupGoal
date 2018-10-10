//
// Created by Anders Borre Hansen on 28/10/14.
// Copyright (c) 2014 Pumodo. All rights reserved.
//

#import "InfoViewController.h"
#import "DefaultViewCell.h"
#import "Identification.h"
#import "DefaultLabel.h"
#import "InfoTableViewCell.h"
#import "Utils.h"
#import "OnboardingPageViewController.h"

@interface InfoViewController ()
@property (nonatomic, strong) NSArray *cells;
@end

@implementation InfoViewController

- (id)init {
    self = [super init];

    if (self) {
        self.title = @"Technical Info";
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.cells = @[
                @{
                        @"title": @"User ID",
                        @"data": [Identification userId]
                },
                @{
                        @"title": @"Device ID",
                        @"data": [Identification deviceVendorId]
                },
                @{
                        @"title": @"App Version",
                        @"data": [Utils appVersion]
                },
                @{
                        @"title": @"Show Onboarding",
                        @"data": @""
                }
        ];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeInfo)];
    }

    return self;
}

- (void)closeInfo {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    InfoTableViewCell *cell = (InfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"infoCell"];

    NSDictionary *cellData = self.cells[(NSUInteger)indexPath.row];

    if (!cell) {
        cell = [[InfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }

    cell.descLabel.text = cellData[@"title"];
    cell.dataLabel.text = cellData[@"data"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.tabBarController.selectedIndex = 0;
        [self.navigationController presentViewController:[[OnboardingPageViewController alloc] init] animated:YES completion:nil];
    } else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        NSDictionary *cellData = self.cells[(NSUInteger)indexPath.row];

        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = cellData[@"data"];
    }
}

@end
