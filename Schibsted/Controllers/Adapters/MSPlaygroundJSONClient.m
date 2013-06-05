//
//  MSPlaygroundJSONClient.m
//  Schibsted
//
//  Created by Marek Serafin on 6/5/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSPlaygroundJSONClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kPlaygroundJsonBaseURL = @"http://rexxars.com/playground/";
NSString * const kPlaygroundJsonDefultAccept = @"application/json";
NSString * const kPlaygroundJsonTestFeed = @"testfeed";

@implementation MSPlaygroundJSONClient

+ (MSPlaygroundJSONClient *)sharedClient
{
    static MSPlaygroundJSONClient *_sharedClient = nil;
    static dispatch_once_t TwitterAPIClientToken;
    dispatch_once(&TwitterAPIClientToken, ^{
        _sharedClient = [[MSPlaygroundJSONClient alloc] initWithBaseURL: [NSURL URLWithString: kPlaygroundJsonBaseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if(self = [super initWithBaseURL: url])
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader: @"Accept"
                         value: kPlaygroundJsonDefultAccept];
    }
    return self;
}

@end
