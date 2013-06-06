//
//  Log.h
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRequestedHostKey;
extern NSString * const kRequestedCountKey;
extern NSString * const kRequestedFileKey;

@interface MSLogItem : NSManagedObject

@property (nonatomic, retain) NSString * requestedHost;
@property (nonatomic, retain) NSString * requestedFile;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * clientHost;
@property (nonatomic, retain) NSString * clientAgent;

+ (void)getDistinctHostsOrderedByRequestsWithBlock:(void (^)(NSArray*items, NSError *error))block;
+ (void)getDistinctFilesWhereHost:(NSString*)host
       orderedByRequestsWithBlock:(void (^)(NSArray*items, NSError *error))block;

@end
