//
//  MSPlaygroundJSONClient.h
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "AFHTTPClient.h"

extern NSString * const kPlaygroundJsonBaseURL;
extern NSString * const kPlaygroundJsonDefultAccept;
extern NSString * const kPlaygroundJsonTestFeed;

@interface MSPlaygroundJSONClient : AFHTTPClient

+ (MSPlaygroundJSONClient *)sharedClient;

@end
