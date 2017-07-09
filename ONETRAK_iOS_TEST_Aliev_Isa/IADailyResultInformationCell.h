//
//  IADailyResultInformationCell.h
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASegmentedView.h"
#import "IADailyResult+CoreDataProperties.h"
#import "IAColoredSelectionCell.h"

@interface IADailyResultInformationCell : IAColoredSelectionCell

@property (weak, nonatomic) IBOutlet IASegmentedView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *walkStepsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *aerobicStepsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *runStepsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) IADailyResult* dailyResult;

@end
