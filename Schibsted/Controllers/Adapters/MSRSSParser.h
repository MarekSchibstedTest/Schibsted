//
//  RSSParser.h
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Modified by Marek Serafin on 6/5/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFXMLRequestOperation.h"
#import "MSRSSItem.h"

extern NSString * const kRSSItemIndexKey;
extern NSString * const kRSSItemDateKey;

@interface MSRSSParser : AFXMLRequestOperation <NSXMLParserDelegate> {
    MSRSSItem *currentItem;
    NSMutableDictionary *channel;
    BOOL canBeChannel;
    NSMutableArray *items;
    NSMutableString *tmpString;
    void (^block)(NSArray *feedItems, NSDictionary *channelInfo);
}



+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems, NSDictionary *channelInfo))success
                       failure:(void (^)(NSError *error))failure;

- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems, NSDictionary *channelInfo))success
                       failure:(void (^)(NSError *error))failure;


@end
