//
//  FastFactsDB.h
//  
//
//  Created by Jon Cohen on 10/2/13.
//  Modified by Mike Caterino in April 2014
//
//  Inspired by the example on http://jona.than.biz/blog/working-with-sqlite-in-objective-cios/

//#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FastFactsDB : NSObject {
    sqlite3 *database;
    const NSString *DB_NAME;
}


- (id)initWithPath: (NSString *)path; //path to database
- (id)initWithName: (NSString *)name; //FastFactsDB
- (NSArray *)queryDB: (NSString *)query; //calls a SQL query
- (NSArray *)findByKeyword: (NSString *)keyword; //finds all articles associated to a keyword
- (NSArray *)findByAuthor: (NSString *)author; //finds all articles by the given author.
- (NSArray *)findByNumber: (int)number;
- (NSArray *)findByArticleBody:(NSString *)articletext;
- (NSArray *)getAllEntries;
- (NSArray *)getFieldFromAllEntries:(int)field;

@end
