//
//  MSLogFileTableViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSLogFileTableViewController.h"
#import "MSLogParser.h"
#import "MSLogItem.h"

#import "MSSimpleCell.h"
#import "MBProgressHUD.h"
#import "MSLogDetailViewController.h"

NSString * const kVarnishLogName = @"varnish.log";

@interface MSLogFileTableViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation MSLogFileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = nil;
    
    [self _importLogFileIntoCoreDataAndDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = NSLocalizedString(@"Lumberjack", nil);
}

#pragma mark - MSLogFileTableViewController (Private)

- (void)_importLogFileIntoCoreDataAndDisplay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![[defaults objectForKey: kVarnishLogName] boolValue]) {
        [self.progressHUD show:YES];
        [self.progressHUD setLabelText: NSLocalizedString(@"Importing logs ...", nil)];
        [MSLogParser importLogFileWithName: kVarnishLogName
                                     block: ^(BOOL status) {
                                         [defaults setBool:YES
                                                    forKey:kVarnishLogName];
                                         [defaults synchronize];
                                         [self _fetchAndReloadData];
                                         [self.progressHUD hide:YES];
                                         [self.progressHUD setLabelText: nil];
                                     }];
    } else {
        [self _fetchAndReloadData];
    }
}

- (void)_fetchAndReloadData
{
    [MSLogItem getDistinctHostsOrderedByRequestsWithBlock:^(NSArray *items, NSError *error) {
        if(!error) {
            self.items = items;
            [self.tableView reloadData];
        } else {
            [self showGenericErrorMessage];
        }
    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier
                                                            forIndexPath: indexPath];

    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    
    [[(MSSimpleCell*)cell titleLabel] setText:[item objectForKey: kRequestedHostKey]];
    [[(MSSimpleCell*)cell descLabel] setText:[NSString stringWithFormat: NSLocalizedString(@"Requests count: %@", nil),
                                              [item objectForKey: kRequestedCountKey]]];
    return cell;
}


#pragma mark - Table view delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    
    [(MSLogDetailViewController*)segue.destinationViewController setCurrentHost: [item objectForKey: kRequestedHostKey]];
}

@end
