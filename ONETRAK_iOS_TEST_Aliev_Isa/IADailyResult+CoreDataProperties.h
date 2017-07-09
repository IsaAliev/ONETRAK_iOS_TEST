//
//  IADailyResult+CoreDataProperties.h
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IADailyResult+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface IADailyResult (CoreDataProperties)

+ (NSFetchRequest<IADailyResult *> *)fetchRequest;

@property (nonatomic) int16_t aerobicCount;
@property (nonatomic) int16_t runCount;
@property (nonatomic) int16_t target;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nonatomic) int16_t walkCount;

@end

NS_ASSUME_NONNULL_END
