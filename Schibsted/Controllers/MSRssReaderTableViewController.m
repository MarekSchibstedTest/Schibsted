//
//  MSRssReaderTableViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSRssReaderTableViewController.h"
#import "MSRSSParser.h"
#import "MSRSSItemCell.h"

#import "NSDate+TimeAgo.h"
#import "UIScrollView+APParallaxHeader.h"
#import "UIImageView+AFNetworking.h"

#import "MSStyleSheet.h"
#import "MBProgressHUD.h"

#import "MSNavigator.h"

NSString * const kRSSFeedURL = @"http://www.vg.no/rss/nyfront.php?frontId=1";
NSString * const kNavBarButtonTextIndex = @"Index Sort";
NSString * const kNavBarButtonTextDate = @"Date Sort";
NSString * const kTableHeaderImagePlaceHolderName = @"placeholder";

static CGFloat const kDefaultTableHeaderHeight = 120.0;

@interface MSRssReaderTableViewController ()

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSArray *items;

@end

@implementation MSRssReaderTableViewController
{
    @private
    BOOL _sortIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView addParallaxWithImage: [UIImage imageNamed: kTableHeaderImagePlaceHolderName]
                               andHeight: kDefaultTableHeaderHeight];
    
    [self _getLatestRSSFeed:nil];
    self.refreshControl = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"RSS is old :)";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: @"Reload"
                                                                                                   target: self
                                                                                                   action: @selector(_getLatestRSSFeed:)];
    
    self.tabBarController.navigationItem.leftBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: kNavBarButtonTextIndex
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
    [self _getLatestRSSFeed:sender];
}

#pragma mark - MSRssReaderTableViewController (Private)

- (void)_getLatestRSSFeed:(id)sender
{
    [self.progressHUD show:YES];
    
    NSURLRequest *rssRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: kRSSFeedURL]];
    [MSRSSParser parseRSSFeedForRequest:rssRequest success:^(NSArray *feedItems,NSDictionary *channelInfo) {
        _sortIndex = YES;
        self.tabBarController.navigationItem.leftBarButtonItem.title = kNavBarButtonTextIndex;
        [self _setChannelInfoElements: channelInfo];
        [self _setTableDataAndSort:feedItems];
        [self.progressHUD hide:YES];
    } failure:^(NSError *error) {
        [self showGenericErrorMessage];
        [self.progressHUD hide:YES];
    }];
}

- (void)_setChannelInfoElements:(NSDictionary*)info
{
    NSArray *urls = [[info valueForKeyPath:@"url"] componentsSeparatedByString:@"\n"];
    [self.tableView.parallaxView.imageView setImageWithURL: [NSURL URLWithString: [urls objectAtIndex:0]]
                                          placeholderImage: [UIImage imageNamed: kTableHeaderImagePlaceHolderName]];
}

- (void)_setTableDataAndSort:(NSArray*)items
{
    self.items = [items sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                      [NSSortDescriptor sortDescriptorWithKey: (!_sortIndex ? kRSSItemDateKey : kRSSItemIndexKey)
                                                                                    ascending: (!_sortIndex ? NO : YES)]]];
    [self.tableView reloadData];
}

- (void)_swapDataSort:(id)sender
{
    _sortIndex = !_sortIndex;
    self.tabBarController.navigationItem.leftBarButtonItem.title = (!_sortIndex ? kNavBarButtonTextDate : kNavBarButtonTextIndex);
    self.items = [self.items sortedArrayUsingDescriptors: [NSArray arrayWithObject:
                                                           [NSSortDescriptor sortDescriptorWithKey: (!_sortIndex ? kRSSItemDateKey : kRSSItemIndexKey)
                                                                                         ascending: (!_sortIndex ? NO : YES)]]];
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
    
    MSRSSItem *item = [self.items objectAtIndex:indexPath.row];
    
    [[(MSRSSItemCell*)cell titleLabel] setText:item.title];
    [[(MSRSSItemCell*)cell dateLabel] setText:[item.pubDate timeAgo]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSRSSItem *item = [self.items objectAtIndex:indexPath.row];
    if(item.link != nil) {
        [self presentViewController: [MSNavigator webViewControllerWithUrl:item.link]
                           animated: YES
                         completion: nil];
    } else {
        [self showGenericErrorMessage];
    }
}

@end
