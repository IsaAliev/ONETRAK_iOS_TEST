//
//  IADataManager.h
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IADailyResult+CoreDataClass.h"
#import "IAErrorPresenter.h"

typedef void (^ErrorHandler)(NSError* error);

@interface IADataManager : NSObject

+ (IADataManager*)sharedManager;

- (void)saveContext;

// Target management

- (void)setTargetSteps:(NSInteger)target;
- (NSInteger)getTargetSteps;

// DailyResult management
- (IADailyResult*)insertNewResultOnError:(ErrorHandler)errorHandler;
- (NSUInteger)resultsCount;
-(NSArray*)allResults;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end
