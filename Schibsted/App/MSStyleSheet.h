//
//  MSStyleSheet.h
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSStyleSheet : NSObject

+ (void)setupAppearance;
+ (UIColor*)navigationBarBackgroundColor;
+ (UIColor*)tabBarBackgroundColor;
+ (UIBarButtonItem*)defaultBarButtonItemWithTitle:(NSString*)title
                                           target:(id)target
                                           action:(SEL)action;
+ (void)showGenericAlertErrorMessageWithTitle:(NSString*)title
                                      message:(NSString*)message;
+ (UIImage*)solidColorImageWithSize:(CGSize)size
                           andColor:(UIColor*)color;

+ (UIFont*)defaultCellTitleFont;
+ (UIFont*)defaultCellSubitleFont;
+ (UIFont*)defaultCellDateFont;
+ (UIFont*)defaultCellBigDateFont;
+ (UIColor*)defaultCellTitleTextColor;
+ (UIColor*)defaultCellSubitleTextColor;
+ (UIColor*)defaultCellDateTextColor;

@end
