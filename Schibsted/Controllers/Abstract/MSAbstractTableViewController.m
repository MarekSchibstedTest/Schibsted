//
//  MSAbstractTableViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSAbstractTableViewController.h"

#import "MSStyleSheet.h"
#import "MBProgressHUD.h"

NSString * const kJsonParserTableViewPullMessageBefore = @"Pull, just a little bit more!";
NSString * const kJsonParserTableViewPullMessageAfter = @"Yeeeah! Now please wait...";

@interface MSAbstractTableViewController ()

@end

@implementation MSAbstractTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.items = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MBProgressHUD*)progressHUD
{
    if(_progressHUD == nil) {
        _progressHUD = [MBProgressHUD showHUDAddedTo: self.view
                                            animated: NO];
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        [_progressHUD hide:NO];
    }
    return _progressHUD;
}

- (void)updateLastTimeUpdate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM YYYY, HH:mm:ss"];
    
    NSString *lastUpdateOn = [NSString stringWithFormat:@"Last update on %@",
                              [dateFormatter stringFromDate:[NSDate date]]];
    
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString: lastUpdateOn]];
}

- (void)showGenericErrorMessage
{
    [MSStyleSheet showGenericAlertErrorMessageWithTitle: @"Error"
                                                message: @"Dude! No internet? C'mon its 2013!"];
}

- (void)setupPullToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [MSStyleSheet navigationBarBackgroundColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:kJsonParserTableViewPullMessageBefore];
    [refreshControl addTarget:self
                       action:@selector(pullToRefreshCallback:)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)pullToRefreshCallback:(id)sender
{
    
}

@end
