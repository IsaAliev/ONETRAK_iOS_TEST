//
//  IAColoredSelectionCell.m
//  ONETRAK_iOS_TEST_Aliev_Isa
//
//  Created by user on 08.07.17.
//  Copyright © 2017 ISA. All rights reserved.
//

#import "IAColoredSelectionCell.h"
#import "Constants.h"

@implementation IAColoredSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView* view = [UIView new];
    
    view.backgroundColor = [walkColor colorWithAlphaComponent:0.5];
    
    self.selectedBackgroundView = view;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
