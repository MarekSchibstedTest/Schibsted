//
//  MSWebViewController.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSWebViewController.h"
#import "MSStyleSheet.h"

@interface MSWebViewController () <UIWebViewDelegate>

@property (copy, nonatomic) NSURL *urlToLoad;

@end

@implementation MSWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Loading ...", nil);
    self.navigationItem.rightBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: NSLocalizedString(@"Close", nil)
                                                                                  target: self
                                                                                  action: @selector(dismiss:)];
    
    self.navigationItem.leftBarButtonItem = [MSStyleSheet defaultBarButtonItemWithTitle: NSLocalizedString(@"Safari", nil)
                                                                                  target: self
                                                                                  action: @selector(openInSafari:)];
    self.webView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.urlToLoad != nil) {
        [self.webView loadRequest: [NSURLRequest requestWithURL:self.urlToLoad]];
    }
}

- (void)loadUrl:(NSURL*)url
{
    self.urlToLoad = url;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.navigationItem.title = title;
}

#pragma mark - MSWebViewController (Private)

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)openInSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL: self.urlToLoad];
}

@end
