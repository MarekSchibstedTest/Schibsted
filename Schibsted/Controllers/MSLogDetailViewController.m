//
//  MSLogDetailViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSLogDetailViewController.h"
#import "MSLogItem.h"
#import "MSSimpleCell.h"
#import "MSNavigator.h"

@interface MSLogDetailViewController ()

@end

@implementation MSLogDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = nil;
    
    self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Top Files (%@)", nil),
                                 self.currentHost];
    
    [self _fetchAndReloadData];
}

#pragma mark - MSLogDetailViewController ()

- (void)_fetchAndReloadData
{
    [MSLogItem getDistinctFilesWhereHost: self.currentHost
              orderedByRequestsWithBlock: ^(NSArray *items, NSError *error) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];
    
    [[(MSSimpleCell*)cell titleLabel] setText:[item objectForKey: kRequestedFileKey]];
    [[(MSSimpleCell*)cell descLabel] setText:[NSString stringWithFormat: NSLocalizedString(@"Requests count: %@", nil),
                                              [item objectForKey: kRequestedCountKey]]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.items objectAtIndex:indexPath.row];

    NSURL *urlToLoad = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",
                                             self.currentHost,
                                             [item objectForKey: kRequestedFileKey]]];
    
    [self presentViewController: [MSNavigator webViewControllerWithUrl: urlToLoad]
                       animated: YES
                     completion: nil];

}

@end
