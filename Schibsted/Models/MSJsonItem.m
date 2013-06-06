//
//  MSJsonItem.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSJsonItem.h"
#import "MSPlaygroundJSONClient.h"

NSString * const kJsonItemDateKey = @"date";

static NSString * const kDateLocale = @"NO";
static NSString * const kDateTimeZone = @"GMT";

@interface MSJsonItem ()

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *link;
@property (strong, nonatomic, readwrite) NSString *desc;
@property (strong, nonatomic, readwrite) NSDate *date;
@property (strong, nonatomic, readwrite) NSString *category;

- (id)initWithAttributes:(NSDictionary*)attributes;

@end

@implementation MSJsonItem

- (id)initWithAttributes:(NSDictionary*)attributes
{
    if(self = [super init]) {
        _title = [attributes valueForKeyPath:@"title"];
        _link = [attributes valueForKeyPath:@"link"];
        _desc = [attributes valueForKeyPath:@"description"];
        _category = [attributes valueForKeyPath:@"category"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier: kDateLocale]];
        [dateFormatter setDateFormat:@"d MMMM y, HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName: kDateTimeZone]];
        
        _date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@, %@",
                                               [attributes valueForKeyPath:@"date"],
                                               [attributes valueForKeyPath:@"time"]]];
    }
    return self;
}

+ (void)getPlaygroundJsonTestFeedItemsWithBlock:(void (^)(NSArray *items, NSError *error))block
{
    [[MSPlaygroundJSONClient sharedClient] getPath: kPlaygroundJsonTestFeed
                                        parameters: nil
                                           success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                               NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
                                               for (NSDictionary *attributes in responseObject) {
                                                   MSJsonItem *jsonItem = [[MSJsonItem alloc] initWithAttributes:attributes];
                                                   [itemsArray addObject: jsonItem];
                                               }
                                               
                                               if (block) {
                                                   block([NSArray arrayWithArray: itemsArray], nil);
                                               }
                                           }
                                           failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                               if (block) {
                                                   block([NSArray array], error);
                                               }
                                           }];
}

@end
