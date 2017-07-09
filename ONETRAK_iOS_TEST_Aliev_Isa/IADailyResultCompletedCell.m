//
//  IADailyResultCompletedCell.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IADailyResultCompletedCell.h"

double const animationDuration = 1.5;
double const animationScaleFactor = 1.5;


@implementation IADailyResultCompletedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Animations

-(void)animateStar {
    [UIView animateKeyframesWithDuration:animationDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.4 animations:^{
            
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(animationScaleFactor, animationScaleFactor), CGAffineTransformMakeRotation(M_PI/3));
            self.starImageView.transform = transform;
            
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(animationScaleFactor, animationScaleFactor), CGAffineTransformMakeRotation(-M_PI/3));
            self.starImageView.transform = transform;
            
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            
            CGAffineTransform transform  = CGAffineTransformIdentity;
            self.starImageView.transform = transform;
            
        }];
        
        
    } completion:nil];
}

@end
