//
//  MSStyleSheet.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSStyleSheet.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"

@implementation MSStyleSheet

+ (void)setupAppearance
{
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont boldFlatFontOfSize:10],
                                                        UITextAttributeFont,
                                                        [UIColor colorWithRed:0.470588 green:0.611765 blue:0.776471 alpha:1.0],
                                                        UITextAttributeTextColor, nil]
                                             forState: UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIFont boldFlatFontOfSize:10],
                                                        UITextAttributeFont,
                                                        [UIColor cloudsColor],
                                                        UITextAttributeTextColor, nil]
                                             forState: UIControlStateHighlighted];
    
    [UIBarButtonItem configureFlatButtonsWithColor:[UIColor peterRiverColor]
                                  highlightedColor:[UIColor belizeHoleColor]
                                      cornerRadius:3];
}

+ (UIColor*)navigationBarBackgroundColor
{
    return [UIColor colorWithRed:0.094118
                           green:0.247059
                            blue:0.423529
                           alpha:1.0];
}

+ (UIColor*)tabBarBackgroundColor
{
    return [UIColor colorWithRed:0.027451
                           green:0.211765
                            blue:0.423529
                           alpha:1.0];
}

+ (UIBarButtonItem*)defaultBarButtonItemWithTitle:(NSString*)title
                                           target:(id)target
                                           action:(SEL)action
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle: title
                                                                      style: UIBarButtonItemStylePlain
                                                                     target: target
                                                                     action: action];
    return barButtonItem;
}

+ (void)showGenericAlertErrorMessageWithTitle:(NSString *)title
                                      message:(NSString *)message
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle: title
                                                          message: message
                                                         delegate: nil
                                                cancelButtonTitle: @"Yeah, whatever!"
                                                otherButtonTitles: nil];

    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [[self class] navigationBarBackgroundColor];
    alertView.defaultButtonColor = [UIColor colorWithRed:0.843137
                                                   green:0.223529
                                                    blue:0.078431
                                                   alpha:1.0];
    alertView.defaultButtonShadowColor = [UIColor colorWithRed:0.670588
                                                         green:0.168627
                                                          blue:0.050980
                                                         alpha:1.0];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor cloudsColor];
    [alertView show];
}

+ (UIImage*)solidColorImageWithSize:(CGSize)size
                           andColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIFont*)defaultCellTitleFont
{
    return [UIFont boldFlatFontOfSize:17];
}

+ (UIFont*)defaultCellSubitleFont
{
    return [UIFont boldFlatFontOfSize:14];
}

+ (UIFont*)defaultCellDateFont
{
    return [UIFont boldFlatFontOfSize:11];
}

+ (UIFont*)defaultCellBigDateFont
{
    return [UIFont boldFlatFontOfSize:13];
}

+ (UIColor*)defaultCellTitleTextColor
{
    return [UIColor midnightBlueColor];
}

+ (UIColor*)defaultCellSubitleTextColor
{
    return [UIColor asbestosColor];
}

+ (UIColor*)defaultCellDateTextColor
{
    return [UIColor belizeHoleColor];
}

@end
