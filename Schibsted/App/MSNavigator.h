//
//  MSNavigator.h
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSNavigator : NSObject

+ (UINavigationController*)webViewControllerWithUrl:(NSURL*)url;

@end
