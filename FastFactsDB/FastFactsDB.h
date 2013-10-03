//
//  FastFactsDB.h
//  
//
//  Created by Jon Cohen on 10/2/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//
//  Inspired by the example on http://jona.than.biz/blog/working-with-sqlite-in-objective-cios/

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FastFactsDB : NSObject {
    sqlite3 *database;
    const NSString *NAME;
}
    
- (id)initWithPath: (NSString *)path; //path to database
- (NSArray *)queryDB: (NSString *)query; //calls a SQL query
- (NSArray *)findByKeyword: (NSString *)keyword; //finds all articles associated to a keyword
- (NSArray *)findByAuthor: (NSString *)author; //finds all articles by the given author.
- (NSArray *)findByNumber: (int)number;

@end
