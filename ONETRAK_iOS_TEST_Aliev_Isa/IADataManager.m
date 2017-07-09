//
//  IADataManager.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IADataManager.h"
#import "Constants.h"

NSString* const kTargetSteps = @"targetStepsKey";

@implementation IADataManager

+(IADataManager*)sharedManager {
    static IADataManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IADataManager alloc] init];
    });
    return manager;
}

#pragma mark CoreData Stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ONETRAK_iOS_TEST_Aliev_Isa"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    [IAErrorPresenter showErrorWithMessage:error.localizedDescription];
                    
                }
            }];
        }
    }
    
    return _persistentContainer;
}


- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        
        [IAErrorPresenter showErrorWithMessage:error.localizedDescription];
    }
}

#pragma mark Target Management

- (void)setTargetSteps:(NSInteger)target {
    [[NSUserDefaults standardUserDefaults] setValue:@(target) forKey:kTargetSteps];
}

- (NSInteger)getTargetSteps {
    
    NSNumber *steps =  [[NSUserDefaults standardUserDefaults] valueForKey:kTargetSteps];
    
    if (steps) {
        return steps.integerValue;
    } else {
        return NoTargetStepsDefined;
    }

}

#pragma mark DailyResult Management

// Для теста
- (NSUInteger)resultsCount {
    
    NSFetchRequest<IADailyResult *> *fetchRequest = IADailyResult.fetchRequest;
    
    return [self.persistentContainer.viewContext countForFetchRequest:fetchRequest error:nil];
    
    
}

-(NSArray*)allResults {
    
    NSFetchRequest<IADailyResult *> *fetchRequest = IADailyResult.fetchRequest;
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    return  [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:nil];
    
}


- (IADailyResult*)insertNewResultOnError:(ErrorHandler)errorHandler; {

    NSManagedObjectContext *context = [self.persistentContainer viewContext];
    IADailyResult *newResult = [[IADailyResult alloc] initWithContext:context];
    
    newResult.timestamp = [NSDate date];

    NSInteger target = [self getTargetSteps];
    
    NSInteger bound = target/2;
    
    // Генерируем более или менее реальные  показатели
    newResult.aerobicCount = arc4random()%(bound-400);
    newResult.walkCount = arc4random()%(bound+300);
    newResult.runCount = arc4random()%(bound);
    newResult.target = target;
    
    // Сохраняем контекст
    NSError *error = nil;
    if (![context save:&error]) {

        if (errorHandler) {
            errorHandler(error);
        }

    }
    
    return newResult;
}

@end
