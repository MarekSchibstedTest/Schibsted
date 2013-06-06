//
//  MSMainTabBarViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSMainTabBarViewController.h"
#import "MSStyleSheet.h"

@interface MSMainTabBarViewController ()

@end

@implementation MSMainTabBarViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self.tabBar setBackgroundImage:[MSStyleSheet solidColorImageWithSize: self.tabBar.bounds.size
                                                                     andColor: [MSStyleSheet tabBarBackgroundColor]]];
        
        NSDictionary *icons = @{
                                @"MSLogFileTableViewController": @"face-cptamerica",
                                @"MSRssReaderTableViewController": @"face-ironman",
                                @"MSJsonParserTableViewController": @"face-wolverine"};
        
        for(UIViewController *controller in self.viewControllers)
        {
            NSString *iconName = icons[NSStringFromClass([controller class])];
            
            [controller.tabBarItem setFinishedSelectedImage: [UIImage imageNamed: iconName]
                                withFinishedUnselectedImage: [UIImage imageNamed: [iconName stringByAppendingFormat:@"-us"]]];
        }
    }
    return self;
}

@end
