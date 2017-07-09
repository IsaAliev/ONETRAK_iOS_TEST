//
//  ONETRAK_iOS_TEST_Aliev_IsaTests.m
//  ONETRAK_iOS_TEST_Aliev_IsaTests
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IADataManager.h"
#import "IAMainViewController.h"

@interface ONETRAK_iOS_TEST_Aliev_IsaTests : XCTestCase
@property (strong, nonatomic) IADataManager* dataManager;
@end

@implementation ONETRAK_iOS_TEST_Aliev_IsaTests

- (void)setUp {
    [super setUp];
    
    self.dataManager = [IADataManager sharedManager];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    self.dataManager = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertingObject {
    
    NSUInteger objectsCountBeforeInsertion = [self.dataManager resultsCount];
    
    [self.dataManager insertNewResultOnError:nil];
    
    NSUInteger objectsCountAfterInsertion = [self.dataManager resultsCount];
    
    XCTAssertEqual(objectsCountBeforeInsertion + 1, objectsCountAfterInsertion, "Object wasn't inserted");
    
}

-(void)testTargetSetting {
    
    NSInteger newTarget = arc4random_uniform(10000);
    
    [self.dataManager setTargetSteps:newTarget];
    
    NSInteger settedTarget = [self.dataManager getTargetSteps];
    
    XCTAssertEqual(newTarget, settedTarget, @"Setting target failed");
    
}

- (void)testDataManager {

    XCTAssertNotNil(self.dataManager, @"Singleton IADataManger is Nill");
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
