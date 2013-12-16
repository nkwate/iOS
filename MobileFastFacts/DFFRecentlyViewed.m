//
//  DFFRecentlyViewed.m
//  MobileFastFacts
//
//  Created by JMAMacUser on 12/16/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "DFFRecentlyViewed.h"

@implementation DFFRecentlyViewed
+(id)alloc  {
    
    return [super alloc];
    
}

-(id)init  {
    
    return [super init];
	queue = [self readFile];
    
}

-(NSMutableArray *)readFile  {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"DFFRecentlyViewed.txt"];
    NSString * file = [NSString stringWithContentsOfFile: filePath];
    NSNumberFormatter *f = [NSNumberFormatter new];
    [f setNumberStyle: NSNumberFormatterNoStyle];
    NSArray *strings = [file componentsSeparatedByString:@" "];
    NSMutableArray *nums = [NSMutableArray new];
    for(int i = 0; i < 10; i += 1)  {
        [nums addObject: [f numberFromString:[strings objectAtIndex: i]]];
    }
    return nums;
    
}

-(void)writeFile  {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"DFFRecentlyViewed.txt"];
	for(int i = 0; i < 10; i+= 1)  {
		[[queue objectAtIndex:i] writeToFile: filePath atomically: YES];
	}
    
}

-(void)updateQueue:(int) inputnum  {
	
	int x = 9;
    NSNumber *num = [NSNumber numberWithInt: inputnum];
	
	if([queue containsObject:num])  {
		x = [queue indexOfObject: num];
	}
	
	if(x < 9)  {
		for(int i = x; i > 0; i -= 1)  {
			[queue replaceObjectAtIndex: i withObject: [queue objectAtIndex:(i-1)]];
		}
		[queue replaceObjectAtIndex: 0 withObject: num];
	}
	
	[self writeFile];
}

-(NSMutableArray *)getQueue  {
	
	return queue;
	
}

@end
