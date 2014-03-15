//
//  DFFRecentlyViewed.h
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 12/16/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.


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
