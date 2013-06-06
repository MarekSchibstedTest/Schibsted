//
//  RSSParser.m
//  RSSParser
//
//  Created by Thibaut LE LEVIER on 1/31/12.
//  Modified by Marek Serafin on 6/5/13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MSRSSParser.h"

NSString * const kRSSItemIndexKey = @"index";
NSString * const kRSSItemDateKey = @"pubDate";

@implementation MSRSSParser

#pragma mark lifecycle
- (id)init {
    self = [super init];
    if (self) {
        items = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -

#pragma mark parser

+ (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                       success:(void (^)(NSArray *feedItems, NSDictionary *channelInfo))success
                       failure:(void (^)(NSError *error))failure
{
    MSRSSParser *parser = [[MSRSSParser alloc] init];
    [parser parseRSSFeedForRequest:urlRequest success:success failure:failure];
}


- (void)parseRSSFeedForRequest:(NSURLRequest *)urlRequest
                                          success:(void (^)(NSArray *feedItems, NSDictionary *channelInfo))success
                                          failure:(void (^)(NSError *error))failure
{
    
    block = [success copy];
    
    AFXMLRequestOperation *operation = [MSRSSParser XMLParserRequestOperationWithRequest:urlRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
        [XMLParser setDelegate:self];
        [XMLParser parse];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *XMLParse) {
        failure(error);
    }];
    [operation start];
}

#pragma mark -

#pragma mark AFNetworking AFXMLRequestOperation acceptable Content-Type overwriting

+ (NSSet *)defaultAcceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml",@"application/rss+xml", nil];
}
+ (NSSet *)acceptableContentTypes {
    return [self defaultAcceptableContentTypes];
}
#pragma mark -

#pragma mark NSXMLParser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"item"]) {
        currentItem = [[MSRSSItem alloc] init];
    }
    
    if ([elementName isEqualToString:@"image"]) {
        channel = [[NSMutableDictionary alloc] init];
        canBeChannel = YES;
    }
    
    tmpString = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{    
    if ([elementName isEqualToString:@"item"]) {
        [items addObject:currentItem];
    }
    if ([elementName isEqualToString:@"image"]) {
        canBeChannel = NO;
    }
    
    if(canBeChannel && tmpString != nil) {
        [channel setObject: tmpString
                    forKey: elementName];
    }

    if (currentItem != nil && tmpString != nil) {
        
        [currentItem setIndex:[NSNumber numberWithInt:[items indexOfObject:currentItem]]];
        
        if ([elementName isEqualToString:@"title"]) {
            [currentItem setTitle:tmpString];
        }
        
        if ([elementName isEqualToString:@"description"]) {
            [currentItem setItemDescription:tmpString];
        }
        
        if ([elementName isEqualToString:@"content:encoded"]) {
            [currentItem setContent:tmpString];
        }
        
        if ([elementName isEqualToString:@"link"]) {
            [currentItem setLink:[NSURL URLWithString:tmpString]];
        }
        
        if ([elementName isEqualToString:@"comments"]) {
            [currentItem setCommentsLink:[NSURL URLWithString:tmpString]];
        }
        
        if ([elementName isEqualToString:@"wfw:commentRss"]) {
            [currentItem setCommentsFeed:[NSURL URLWithString:tmpString]];
        }
        
        if ([elementName isEqualToString:@"slash:comments"]) {
            [currentItem setCommentsCount:[NSNumber numberWithInt:[tmpString intValue]]];
        }
        
        if ([elementName isEqualToString:@"pubDate"]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

            NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_EN"];
            [formatter setLocale:local];
          
            [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            
            [currentItem setPubDate:[formatter dateFromString:tmpString]];
        }

        if ([elementName isEqualToString:@"dc:creator"]) {
            [currentItem setAuthor:tmpString];
        }
        
        if ([elementName isEqualToString:@"guid"]) {
            [currentItem setGuid:tmpString];
        }
    }
    
    if ([elementName isEqualToString:@"rss"]) {
        block(items, [NSDictionary dictionaryWithDictionary:channel]);
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [tmpString appendString:string];
    
}

#pragma mark -

@end
