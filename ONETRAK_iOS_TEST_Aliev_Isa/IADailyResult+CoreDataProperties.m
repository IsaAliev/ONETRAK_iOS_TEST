//
//  IADailyResult+CoreDataProperties.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IADailyResult+CoreDataProperties.h"

@implementation IADailyResult (CoreDataProperties)

+ (NSFetchRequest<IADailyResult *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"IADailyResult"];
}

@dynamic aerobicCount;
@dynamic runCount;
@dynamic target;
@dynamic timestamp;
@dynamic walkCount;

@end
