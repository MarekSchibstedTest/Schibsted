//
//  MSAbstractTableViewController.h
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kJsonParserTableViewPullMessageBefore;
extern NSString * const kJsonParserTableViewPullMessageAfter;

@class MBProgressHUD;

@interface MSAbstractTableViewController : UITableViewController

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSArray *items;

- (void)updateLastTimeUpdate;
- (void)showGenericErrorMessage;
- (void)setupPullToRefresh;
- (void)pullToRefreshCallback:(id)sender;

@end
