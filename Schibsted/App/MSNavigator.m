//
//  MSNavigator.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSNavigator.h"
#import "MSMainNavigationViewController.h"
#import "MSWebViewController.h"

NSString * const kWebViewControllerIdentifier = @"WebView";

@implementation MSNavigator

+ (UINavigationController*)webViewControllerWithUrl:(NSURL*)url
{
    NSString *storyboardName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: storyboardName
                                                         bundle: nil];
    
    MSWebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier: kWebViewControllerIdentifier];
    [webViewController loadUrl:url];
    
    MSMainNavigationViewController *navigationController = [[MSMainNavigationViewController alloc] initWithRootViewController: webViewController];
    
    return navigationController;
}

@end
