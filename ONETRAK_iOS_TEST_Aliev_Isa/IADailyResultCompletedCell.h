//
//  IADailyResultCompletedCell.h
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAColoredSelectionCell.h"

@interface IADailyResultCompletedCell : IAColoredSelectionCell

@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

-(void)animateStar;

@end
