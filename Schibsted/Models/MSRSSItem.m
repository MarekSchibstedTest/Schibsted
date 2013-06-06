//
//  RSSItem.m
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 2/3/12.
//  Modified by Marek Serafin on 6/5/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSRSSItem.h"

@interface MSRSSItem (Private)

-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr;

@end

@implementation MSRSSItem

@synthesize index,title,itemDescription,content,link,commentsLink,commentsFeed,commentsCount,pubDate,author,guid;

-(NSArray *)imagesFromItemDescription
{
    if (self.itemDescription) {
        return [self imagesFromHTMLString:self.itemDescription];
    }
    
    return nil;
}

-(NSArray *)imagesFromContent
{
    if (self.content) {
        return [self imagesFromHTMLString:self.content];
    }
    
    return nil;
}

#pragma mark - retrieve images from html string using regexp (private methode)

-(NSArray *)imagesFromHTMLString:(NSString *)htmlstr
{
    NSMutableArray *imagesURLStringArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSRegularExpression *regex = [NSRegularExpression         
                                  regularExpressionWithPattern:@"(https?)\\S*(png|jpg|jpeg|gif)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    [regex enumerateMatchesInString:htmlstr 
                            options:0 
                              range:NSMakeRange(0, htmlstr.length) 
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             [imagesURLStringArray addObject:[htmlstr substringWithRange:result.range]];
                         }];    
    
    return [NSArray arrayWithArray:imagesURLStringArray];
}

@end
