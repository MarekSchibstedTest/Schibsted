//
//  Log.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSLogItem.h"

NSString * const kRequestedHostKey = @"requestedHost";
NSString * const kRequestedFileKey = @"requestedFile";
NSString * const kRequestedCountKey = @"counter";
static int const kResultsLimit = 5;

@implementation MSLogItem

@dynamic requestedHost;
@dynamic requestedFile;
@dynamic date;
@dynamic clientHost;
@dynamic clientAgent;

+ (void)getDistinctHostsOrderedByRequestsWithBlock:(void (^)(NSArray*items, NSError *error))block;
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MSLogItem entityName]];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName: [MSLogItem entityName]
                                              inManagedObjectContext: [[CoreDataManager instance] managedObjectContext]];
    
    NSPropertyDescription *propDesc = [[entity propertiesByName] objectForKey: kRequestedHostKey];
    
    NSExpression *hostExpr = [NSExpression expressionForKeyPath: kRequestedHostKey];
    NSExpression *countExpr = [NSExpression expressionForFunction: @"count:"
                                                        arguments: [NSArray arrayWithObject:hostExpr]];
    
    NSExpressionDescription *exprDesc = [[NSExpressionDescription alloc] init];
    [exprDesc setExpression:countExpr];
    [exprDesc setExpressionResultType:NSInteger64AttributeType];
    [exprDesc setName: kRequestedCountKey];
        
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:propDesc]];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects: propDesc, exprDesc, nil]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *items = [[[CoreDataManager instance] managedObjectContext] executeFetchRequest: fetchRequest
                                                                                      error: &error];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: kRequestedCountKey
                                                         ascending: NO];
    
    items = [items sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    items = [items subarrayWithRange:NSMakeRange(0, kResultsLimit)];
    
    if(error != nil) {
        block([NSArray array], error);
    } else {
        block(items, nil);
    }
}

+ (void)getDistinctFilesWhereHost:(NSString*)host
       orderedByRequestsWithBlock:(void (^)(NSArray*items, NSError *error))block;
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[MSLogItem entityName]];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName: [MSLogItem entityName]
                                              inManagedObjectContext: [[CoreDataManager instance] managedObjectContext]];
    
    NSPropertyDescription *propDesc = [[entity propertiesByName] objectForKey: kRequestedFileKey];
    
    NSExpression *hostExpr = [NSExpression expressionForKeyPath: kRequestedFileKey];
    NSExpression *countExpr = [NSExpression expressionForFunction: @"count:"
                                                        arguments: [NSArray arrayWithObject:hostExpr]];
    
    NSExpressionDescription *exprDesc = [[NSExpressionDescription alloc] init];
    [exprDesc setExpression:countExpr];
    [exprDesc setExpressionResultType:NSInteger64AttributeType];
    [exprDesc setName: kRequestedCountKey];
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"%K == %@",
                                   kRequestedHostKey,
                                   host];
    
    [fetchRequest setPredicate:fetchPredicate];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:propDesc]];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects: propDesc, exprDesc, nil]];
    [fetchRequest setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *items = [[[CoreDataManager instance] managedObjectContext] executeFetchRequest: fetchRequest
                                                                                      error: &error];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: kRequestedCountKey
                                                         ascending: NO];
    
    items = [items sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    items = [items subarrayWithRange:NSMakeRange(0, kResultsLimit)];
    
    if(error != nil) {
        block([NSArray array], error);
    } else {
        block(items, nil);
    }
}

@end
