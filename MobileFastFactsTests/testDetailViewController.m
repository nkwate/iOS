//
//  testDetailController.m
//  MobileFastFacts
//
//  Created by Jeff Jackson on 10/29/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "DetailViewController.h"

@interface testDetailViewController : SenTestCase

@end

@implementation testDetailViewController

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFormatFileName
{
    STAssertEqualObjects([DetailViewController formatFileName:7], @"ff_007", @"Incorrect name");
    STAssertEqualObjects([DetailViewController formatFileName:17], @"ff_017", @"Incorrect name");
    STAssertEqualObjects([DetailViewController formatFileName:177], @"ff_177", @"Incorrect name");
}

@end
