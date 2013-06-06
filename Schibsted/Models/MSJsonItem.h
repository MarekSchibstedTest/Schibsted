//
//  MSJsonItem.h
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kJsonItemDateKey;

@interface MSJsonItem : NSObject

@property (readonly) NSString *title;
@property (readonly) NSString *link;
@property (readonly) NSString *desc;
@property (readonly) NSDate *date;
@property (readonly) NSString *category;

+ (void)getPlaygroundJsonTestFeedItemsWithBlock:(void (^)(NSArray *items, NSError *error))block;

@end
