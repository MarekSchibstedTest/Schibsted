//
//  MSWebViewController.h
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSWebViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)loadUrl:(NSURL*)url;

@end
