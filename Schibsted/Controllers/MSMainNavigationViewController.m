//
//  MSMainNavigationViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSMainNavigationViewController.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "MSStyleSheet.h"

@interface MSMainNavigationViewController ()

@end

@implementation MSMainNavigationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder: aDecoder]) {
        [self _configureNavBar];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super initWithRootViewController: rootViewController]) {
        [self _configureNavBar];
    }
    return self;
}

#pragma mark - MSMainNavigationViewController (Private)

- (void)_configureNavBar
{
    [self.navigationBar configureFlatNavigationBarWithColor:[MSStyleSheet navigationBarBackgroundColor]];
}

@end
