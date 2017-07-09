//
//  IADailyResultInformationCell.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IADailyResultInformationCell.h"

@implementation IADailyResultInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Setters

// Переопределение сеттера для самоконфигурирования
-(void)setDailyResult:(IADailyResult *)dailyResult {
    _dailyResult = dailyResult;
    
    NSInteger sum = dailyResult.walkCount + dailyResult.runCount + dailyResult.aerobicCount;
    
    double walkPercentage = (double)dailyResult.walkCount/sum;
    double aerobicPercentage = (double)dailyResult.aerobicCount/sum;
    double runPercentage = (double)dailyResult.runCount/sum;
    
    self.progressView.percentageArray = @[@(walkPercentage), @(aerobicPercentage), @(runPercentage)];
    self.walkStepsCountLabel.text = [NSString stringWithFormat:@"%d", dailyResult.walkCount];
    self.runStepsCountLabel.text = [NSString stringWithFormat:@"%d", dailyResult.runCount];
    self.aerobicStepsCountLabel.text = [NSString stringWithFormat:@"%d", dailyResult.aerobicCount];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MM.yyyy";
    
    self.dateLabel.text = [formatter stringFromDate:dailyResult.timestamp];
    self.resultLabel.text = [NSString stringWithFormat:@"%ld / %d steps",(long)sum, dailyResult.target];
    
    self.progressView.backgroundColor = [UIColor whiteColor];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSComparisonResult res =  [calendar compareDate:dailyResult.timestamp toDate:[NSDate date] toUnitGranularity:NSCalendarUnitSecond];
    
    // Анимируем прогресс бар при совпадении настоящего времени и времени создания объекта с точностью до секунд
    
    [self.progressView revealAnimated: res == NSOrderedSame];
}

@end
