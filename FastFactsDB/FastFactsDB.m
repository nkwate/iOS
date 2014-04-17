//
//  FastFactsDB.m
//  
//
//  Created by Jon Cohen on 10/2/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "FastFactsDB.h"
//#import <Foundation/Foundation.h>
#import <sqlite3.h>

@implementation FastFactsDB

- (id) initWithPath: (NSString *)path {
    //Returns the database located at <path>, or else nil if there is none.
    if (self = [super init]) { //ie not a database
        sqlite3 *dbConnection;
        if (sqlite3_open([path UTF8String], &dbConnection) != SQLITE_OK) { //can't find database
            NSLog(@"sqlite cannot find the database");
            return nil;
        }
        database = dbConnection;
    }
    
    DB_NAME = @"FastFactsDB";
    return self;
}

-(id) initWithName: (NSString *)dbName {
    NSBundle *bundle = [NSBundle bundleForClass: [self class]];
    NSString *DBPath;
    if ((DBPath = [bundle pathForResource:@"FastFactsDB" ofType:@"sqlite3"])) {
        self = [self initWithPath:DBPath];
    }
    //NSLog(DBPath);
    return self;
}

- (NSArray *)queryDB: (NSString *)query {
    //Queries database with SQL command <query> and returns an array containing all the resulting rows
    //Most other methods in this class build off of this one.
    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    
    if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) { //this replaces the nil in statement
        NSLog(@"Invalid query!"); 
    } else {
        NSMutableArray *result = [NSMutableArray array]; //container for output
        //build output array
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row = [NSMutableArray array];
            for (int i = 0; i < sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithFormat: @"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"Something got through the database filter");
                }
                
                [row addObject:value];
                
            } //for
            [result addObject:row];
        } //while
        return result;
    } //if
    return nil;
}

- (NSArray *)findByKeyword:(NSString *)keyword {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=1", DB_NAME, keyword];
    return [self queryDB:query];
}

-(NSArray *)findByAuthor:(NSString *)author {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE author=%@", DB_NAME, author];
    return [self queryDB:query];
}

-(NSArray *)findByNumber:(int)number {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE number=%d", DB_NAME, number];
    return [self queryDB:query];
}

-(NSArray *)findByArticleBody:(NSString *)articletext {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE short_name LIKE '%%%@%%'", DB_NAME, articletext];
    
    return [self queryDB:query];
}

-(NSArray *)getAllEntries {
    return [self queryDB:[NSString stringWithFormat:@"SELECT * FROM %@", DB_NAME]];
}

-(NSArray *)getFieldFromAllEntries:(int)field { //field should be taken from the header constants
    NSMutableArray *fields = [NSMutableArray array];
    NSArray *table = [self getAllEntries];
    for (NSArray *row in table) {
       [fields addObject:[row objectAtIndex:field]];
    }
    return fields;
}


@end
