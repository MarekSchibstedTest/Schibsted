//
//  MSLogParser.m
//  Schibsted
//
//  Created by Marek Serafin on 6/6/13.
//  Copyright (c) 2013 Marek Serafin. All rights reserved.
//

#import "MSLogParser.h"
#import "MSLogItem.h"

static NSString * const kDateTimeZone = @"GMT";

@implementation MSLogParser

- (id)init
{
    if(self = [super init]) {
        
    }
    return self;
}

+ (void)importLogFileWithName: (NSString*)logFileName
                        block: (void (^)(BOOL status))block
{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        MSLogParser *logParser = [[MSLogParser alloc] init];
        [logParser importLogFileWithName: logFileName
                                   block: block];
    });
}

- (void)importLogFileWithName: (NSString*)logFileName
                        block: (void (^)(BOOL status))block
{
    NSString* logFilePath = [[NSBundle mainBundle] pathForResource: logFileName
                                                            ofType: nil];
    
    NSString* logFileContent = [NSString stringWithContentsOfFile: logFilePath
                                                         encoding: NSUTF8StringEncoding
                                                            error: NULL];
    
    NSMutableArray *logFileLines = [[logFileContent componentsSeparatedByCharactersInSet:
                                     [NSCharacterSet newlineCharacterSet]] mutableCopy];
    
    for (NSString *singleLine in logFileLines) {
        [self _parseSingleLogSineIntoDictionary: singleLine];
    }

    BOOL status = [[CoreDataManager instance] saveContext];
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        block(status);
    });
}

#pragma mark - MSLogParser (Private)

- (void)_parseSingleLogSineIntoDictionary:(NSString*)line
{
    NSError *error = NULL;
    
    NSString *regularExpressionPattern = @"^(\\S+) \\S+ \\S+ \\[([^]]+)\\] \"([A-Z]+) (\\S+) [^\"]*\" \\d+ \\d+ \"\\S+\" \"([^\"]*)\"$";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern: regularExpressionPattern
                                                                                       options: NSRegularExpressionCaseInsensitive
                                                                                         error: &error];
    NSArray *matches = [regularExpression matchesInString: line
                                                  options: 0
                                                    range: NSMakeRange(0, [line length])];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"d/MMM/y:H:m:s z"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName: kDateTimeZone]];
    
    for (NSTextCheckingResult *match in matches) {
        
        NSURL *requestedURL = [NSURL URLWithString: [line substringWithRange: [match rangeAtIndex:4]]];

        NSDate *date = [dateFormatter dateFromString:[line substringWithRange: [match rangeAtIndex:2]]];
        
        MSLogItem *logItem = [MSLogItem create];
        
        logItem.clientAgent = [line substringWithRange: [match rangeAtIndex:5]];
        logItem.clientHost = [line substringWithRange: [match rangeAtIndex:1]];
        logItem.date = date;
        logItem.requestedHost = requestedURL.host;
        logItem.requestedFile = requestedURL.path;
    }
}

@end
