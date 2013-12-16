//
//  DFFRecentlyViewed.h
//  MobileFastFacts
//
//  Created by JMAMacUser on 12/16/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFFRecentlyViewed : NSObject  {
    NSNumber *length;
    NSMutableArray *queue;
}

+(id)alloc;
-(id)init;
-(NSMutableArray *)readFile;
-(void)writeFile;
-(void)updateQueue:(int) num;
-(NSMutableArray *)getQueue;

@end
