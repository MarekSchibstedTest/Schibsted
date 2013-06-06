//
//  MSJsonParserTableViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSJsonParserTableViewController.h"
#import "MSJsonItem.h"
#import "MSJsonItemCell.h"

#import "MSStyleSheet.h"
#import "MBProgressHUD.h"

@interface MSJsonParserTableViewController ()

- (void)_getLatestPlaygroundJsonTestFeed:(id)sender;

@end

@implementation MSJsonParserTableViewController
{
    @private
    BOOL _sortAsc;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        _sortAsc = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _getLatestPlaygroundJsonTestFeed:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Hello JSON!";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: @"Reload"
                                                                                                   target: self
                                                                                                   action: @selector(_getLatestPlaygroundJsonTestFeed:)];
    
    self.tabBarController.navigationItem.leftBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: @"Swap Sort"
                                                                                                  target: self
                                                                                                  action: @selector(_swapDataSort:)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)pullToRefreshCallback:(id)sender
{
    [super pullToRefreshCallback:sender];
    [self _getLatestPlaygroundJsonTestFeed:sender];
}

#pragma mark - MSJsonParserTableViewController (Private)

- (void)_getLatestPlaygroundJsonTestFeed:(id)sender
{
    if([sender isMemberOfClass:[UIRefreshControl class]]) {
        [sender setAttributedTitle:[[NSAttributedString alloc] initWithString:kJsonParserTableViewPullMessageAfter]];
    } else {
        [self.progressHUD show:YES];
    }
    
    [MSJsonItem getPlaygroundJsonTestFeedItemsWithBlock:^(NSArray *items, NSError *error) {
        if([sender isMemberOfClass:[UIRefreshControl class]]) {
            [self.refreshControl endRefreshing];
        } else {
            [self.progressHUD hide:YES];
        }
        if(!error) {
            [self _setTableDataAndSort:items];
            [self updateLastTimeUpdate];
        } else {
            [self showGenericErrorMessage];
        }
    }];

}

- (void)_setTableDataAndSort:(NSArray*)items
{
    _sortAsc = NO;
    self.items = [items sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                      [NSSortDescriptor sortDescriptorWithKey: kJsonItemDateKey
                                                                                    ascending: _sortAsc]]];
    [self.tableView reloadData];
}

- (void)_swapDataSort:(id)sender
{
    _sortAsc = !_sortAsc;
    self.items = [self.items sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                           [NSSortDescriptor sortDescriptorWithKey: kJsonItemDateKey
                                                                                         ascending: _sortAsc]]];
    [self.tableView reloadSections: [NSIndexSet indexSetWithIndex:0]
                  withRowAnimation: UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [self.items count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MSJsonItem *item = [self.items objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY, HH:mm:ss"];
    
    NSString *date = [NSString stringWithFormat:@"Date: %@, Category: %@",
                      [dateFormatter stringFromDate:[item date]],
                      (![item category] ? @"None" : [item category])];
    
    [[(MSJsonItemCell*)cell titleLabel] setText:[item title]];
    [[(MSJsonItemCell*)cell descLabel] setText:[item desc]];
    [[(MSJsonItemCell*)cell dateLabel] setText:date];
    
    return cell;
}

@end
